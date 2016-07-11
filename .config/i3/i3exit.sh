#!/bin/sh

# Adapted from an answer posted by 'VOid' on
# 'https://faq.i3wm.org/question/239/how-do-i-suspendlockscreen-and-logout.1.html'

# requires scrot and ImageMagick to work

case "$1" in
    lock)
        bash ~/.config/i3/lock_helper.bash dkms
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        bash ~/.config/i3/lock_helper.bash fork && systemctl suspend
        ;;
    hibernate)
        bash ~/.config/i3/lock_helper.bash fork && systemctl hibernate
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
