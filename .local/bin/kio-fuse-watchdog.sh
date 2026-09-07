#!/bin/bash
# Force-unmounts kio-fuse mounts (Dolphin sftp:// bookmarks etc.) that stop
# responding, so a dropped/changed network connection can't wedge the whole
# system in uninterruptible sleep. Runs periodically via a systemd user timer.
#
# Never stats or opens anything *inside* a mount while deciding whether it's
# stuck -- that would risk the check itself hanging. Busy-detection reads
# only the (kernel-maintained) /proc/*/fd/* symlink targets, never resolving
# them, and the responsiveness probe is bounded and never waited on past its
# timeout.
#
# A held-open fd alone doesn't mean "busy": if the connection died mid
# transfer, the copying process blocks inside read()/write() and never gets
# to close() its fd, so the fd stays open forever with zero further
# progress. To tell a real transfer from that, we track the I/O byte
# counters (/proc/PID/io) of processes holding an fd into the mount across
# cycles -- unchanged counters despite an open fd means stalled, not busy.

set -uo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/kio-fuse-watchdog"
mkdir -p "$STATE_DIR"

CHECK_TIMEOUT=8   # seconds to wait for a responsiveness probe
MAX_STRIKES=3     # consecutive unresponsive checks before force-unmount

log() { logger -t kio-fuse-watchdog -- "$*"; }

# PIDs currently holding an open fd somewhere under $1, one per line.
pids_with_open_fd() {
    local prefix="$1" fd link pid
    declare -A seen=()
    for fd in /proc/[0-9]*/fd/*; do
        # Plain readlink only: it returns the kernel's cached path string for
        # the open file description and never touches the target filesystem,
        # so it can't block even if the mount behind it is dead.
        link=$(readlink -- "$fd" 2>/dev/null) || continue
        [[ "$link" == "$prefix"* ]] || continue
        pid="${fd#/proc/}"; pid="${pid%%/*}"
        seen["$pid"]=1
    done
    printf '%s\n' "${!seen[@]}"
}

# Sum of rchar+wchar across the given PIDs. /proc/PID/io is procfs
# bookkeeping -- reading it doesn't touch the mount either.
io_sum_for_pids() {
    local pid sum=0 val
    for pid in "$@"; do
        [[ -n "$pid" && -r "/proc/$pid/io" ]] || continue
        val=$(awk '/^(rchar|wchar):/ { s += $2 } END { print s + 0 }' "/proc/$pid/io" 2>/dev/null)
        sum=$((sum + ${val:-0}))
    done
    echo "$sum"
}

check_mount() {
    local mnt="$1" state_file strikes prev_io probe_pid i
    local -a lines pids

    state_file="$STATE_DIR/$(echo "$mnt" | tr '/' '_')"
    strikes=0
    prev_io=""
    if [[ -f "$state_file" ]]; then
        mapfile -t lines < "$state_file"
        strikes="${lines[0]:-0}"
        prev_io="${lines[1]:-}"
    fi

    mapfile -t pids < <(pids_with_open_fd "$mnt")

    if (( ${#pids[@]} > 0 )); then
        local io_sum
        io_sum=$(io_sum_for_pids "${pids[@]}")
        if [[ -z "$prev_io" || "$io_sum" != "$prev_io" ]]; then
            # Either the first cycle we've seen an fd here, or bytes are
            # actually moving -- give it the benefit of the doubt.
            [[ "$strikes" != 0 ]] && log "$mnt: busy (I/O progressing), resetting strike count"
            printf '0\n%s\n' "$io_sum" > "$state_file"
            return
        fi
        log "$mnt: open fd present but no I/O progress since last check, treating as stalled"
        # Fall through to the responsiveness probe below; keep io_sum as-is
        # so we can still write it back at the end.
    fi

    ( stat "$mnt" >/dev/null 2>&1 ) &
    probe_pid=$!
    for ((i = 0; i < CHECK_TIMEOUT; i++)); do
        kill -0 "$probe_pid" 2>/dev/null || break
        sleep 1
    done

    if kill -0 "$probe_pid" 2>/dev/null; then
        strikes=$((strikes + 1))
        printf '%s\n%s\n' "$strikes" "$prev_io" > "$state_file"
        log "$mnt: unresponsive (strike $strikes/$MAX_STRIKES)"
        if (( strikes >= MAX_STRIKES )); then
            log "$mnt: exceeded $MAX_STRIKES strikes, forcing lazy unmount"
            fusermount -uz -- "$mnt" 2>&1 | logger -t kio-fuse-watchdog
            rm -f "$state_file"
        fi
        # Note: the backgrounded probe above may itself now be stuck in
        # uninterruptible sleep. That's expected and harmless -- it will
        # clear on its own once the kernel finishes tearing down the FUSE
        # connection after the force-unmount.
    else
        [[ "$strikes" != 0 ]] && log "$mnt: responsive again, resetting strike count"
        rm -f "$state_file"
    fi
}

mapfile -t mounts < <(findmnt -rn -t fuse.kio-fuse -o TARGET 2>/dev/null)
for m in "${mounts[@]}"; do
    check_mount "$m"
done
