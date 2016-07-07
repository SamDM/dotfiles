#!/usr/bin/bash

VOL=$(bash ~/.config/i3/pactl_helper.bash --query_volume)

if   [ $VOL = "M" ]; then
    echo "  $VOL"
elif [ $VOL -lt 33 ]; then
    echo "  $VOL"
elif [ $VOL -lt 66 ]; then
    echo "  $VOL"
else
    echo " $VOL"
fi
