from i3pystatus import Status

status = Status()

col_blush="#BC4676"
col_sea  ="#65AA8C"

# Displays clock and date
status.register("clock",
        on_leftclick = "firefox https://calendar.google.com/calendar/render#main_7",
        format="  %a %-d %b   %H:%M",)

status.register("mem",
        divisor=2**30,
        alert_color=col_blush,
        color="#FFFFFF",
        format=" {used_mem}:{avail_mem}G")

# Shows the average load of the last 5 and 15 minutes
status.register("load",
        critical_color=col_blush,
        format="{avg5} {avg15}",)

status.register("cpu_usage",
        # critical_color=col_blush,
        format="  {usage:02d}%",)

# The battery monitor
status.register("battery",
    format="{status} {consumption:02.0f}W [{percentage_design:.0f}%] {remaining:%E%hh:%Mm}",
    alert=False,
    alert_percentage=20,
    critical_level_percentage=20,
    full_color=col_sea,
    charging_color=col_sea,
    status={
        "DIS":  " ",
        "CHR":  " ",
        "FULL": " ",
    },)

# Shows network and up/down state
# Note: the network module requires PyPI package netifaces
status.register("network",
    interface="enp7s0",
    start_color=col_sea,
    end_color=col_blush,
    color_down=col_blush,
    format_up="  {bytes_recv:04d} {bytes_sent:04d}",
    format_down="  {bytes_recv:04d} {bytes_sent:04d}")

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlp8s0",
    start_color=col_sea,
    end_color=col_blush,
    color_down=col_blush,
    format_up="  {bytes_recv:04d} {bytes_sent:04d}",
    format_down="  {bytes_recv:04d} {bytes_sent:04d}")

# Shows disk usage
status.register("disk",
    path="/home",
    format="/home {avail}G",)
status.register("disk",
    path="/",
    format="  / {avail}G",)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    color_muted=col_blush,
    vertical_bar_width=1,
    format="{volume_bar} {volume}%",)

# Shows mpd status
status.register("mpd",
    format="{title}{status}{album}",
    status={
        "pause": "",
        "play":  "",
        "stop":  "",
    },)

status.run()
