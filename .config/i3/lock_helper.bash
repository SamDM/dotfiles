#!/bin/bash

# Source: discussion from wontonspecial, LimpingLlama and V13Axel on Reddit
# thread: '[i3lock] unixporn-worthy lock screen'
# URL: 'http://pastebin.com/kRDHSVbM'

# dependencies:
# scrot      -- for taking screenshots
# ImageMagic -- for command line image manipulations

scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png

IMAGE=~/.config/i3/lock.png

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

        convert /tmp/screen.png $IMAGE -geometry +$PX+$PY -composite -matte  /tmp/screen.png
    done
fi

i3lock -e -d -I 30 -f -i /tmp/screen.png
