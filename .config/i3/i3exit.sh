#!/bin/sh

# Adapted from an answer posted by 'VOid' on
# 'https://faq.i3wm.org/question/239/how-do-i-suspendlockscreen-and-logout.1.html'

lock() {
    # requires scrot and ImageMagick to work
    bash ~/.config/i3/lock_helper.bash
}

case "$1" in
    lock)
        lock
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        lock && systemctl suspend
        ;;
    hibernate)
        lock && systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
