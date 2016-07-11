#!/bin/bash

# Source: discussion from wontonspecial, LimpingLlama and V13Axel on Reddit
# thread: '[i3lock] unixporn-worthy lock screen'
# URL: 'http://pastebin.com/kRDHSVbM'

# dependencies:
# scrot      -- for taking screenshots
# ImageMagic -- for command line image manipulations

SCREENSHOT=$(mktemp --suffix .png)
IMAGE=~/.config/i3/lock.png

scrot $SCREENSHOT
convert $SCREENSHOT -scale 10% -scale 1000% $SCREENSHOT

if [[ -f $IMAGE ]]
then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file -L $IMAGE | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)

    SR=$(xrandr --query | grep ' connected' | sed 's/primary //' | cut -f3 -d' ')
    for RES in $SR
    do
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))

        convert $SCREENSHOT $IMAGE -geometry +$PX+$PY -composite -matte  $SCREENSHOT
    done
fi

revert() {
  xset dpms 0 0 0
}

disable_vol() {
    ORIG_PROFILE=$(pactl list | grep 'Active Profile' | cut -d: -f2,3)
    # by turning of the sound card, no settings (sinks/volume) are changed
    pactl set-card-profile alsa_card.pci-0000_00_1b.0 off
}

restore_vol() {
    # re-enable the previous profile
    pactl set-card-profile alsa_card.pci-0000_00_1b.0 $ORIG_PROFILE
}

case "$1" in
    dkms)
        # for normal locking, enable dkms, and disable sound
        disable_vol
        trap revert SIGHUP SIGINT SIGTERM
        xset +dpms dpms 5 5 5
        i3lock -n -e -I 30 -f -i $SCREENSHOT
        # if the password is entered correctly, i3 finishes and stops blocking
        # this thread. Then disable dkms and restore volume to previous state
        revert
        restore_vol
        ;;
    fork)
        # for suspend/hibernate, don't enable dkms and fork i3lock such that
        # suspend/hibernate can take place
        i3lock -e -I 30 -f -i $SCREENSHOT
        ;;
    *)
        exit 1
esac
