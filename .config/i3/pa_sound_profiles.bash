#!/bin/bash

# Helper script to quickly configure audio devices from the command line. The
# profiles are found by slamming `pacmd dump` into a terminal and and then
# fiddling around with the output untill all error messages are gone.

# This script requires only pulseaudio, there is no need to install alsa-utils
# or pulseaudio-alsa, tbh I have no clue how alsa and pulseaudio are related.

function print_help {
cat <<EOF
--HDMI
    send audio to HDMI device
--HDMI-sensible
    send audio to HDMI device, and set all volumes to 100%
--laptop
    send audio to laptop output, that is the speakers if no jack is connected,
    or the jack if there is one available
--headphones-sensible
    send audio to laptop and set volume to 15%, ideal if you whish to use
    headphones connected throught the jack
--speakers-sensible
    send audio to laptop and set volume to 30%, ideal if you whish to use
    the horrible built-in laptop speakers
--woofer-sensible
    send audio to laptop and set volume to 100%, ideal if you whish to use
    speakers connected throught the jack
--help
    print this help
EOF
}

function profile_HDMI {
    # use HDMI output, no clue about the details but it seems to work
    pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:hdmi-stereo
    pacmd set-default-sink alsa_output.pci-0000_00_1b.0.hdmi-stereo
    pacmd set-default-source alsa_output.pci-0000_00_1b.0.hdmi-stereo.monitor
}

function sensible_vol_HDMI {
    # volume to 100%, don't mute and something else I don't understand...
    pacmd set-sink-volume alsa_output.pci-0000_00_1b.0.hdmi-stereo 0x10000
    pacmd set-sink-mute alsa_output.pci-0000_00_1b.0.hdmi-stereo no
    pacmd suspend-sink alsa_output.pci-0000_00_1b.0.hdmi-stereo no
    # source volume / sink volume, what's the difference?
    pacmd set-source-volume alsa_output.pci-0000_00_1b.0.hdmi-stereo.monitor 0x10000
    pacmd set-source-mute alsa_output.pci-0000_00_1b.0.hdmi-stereo.monitor no
}

function profile_laptop {
    # use laptop laptop, no clue about the details but it seems to work
    pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo+input:analog-stereo
    pacmd set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
    pacmd set-default-source alsa_input.pci-0000_00_1b.0.analog-stereo
}

function sensible_settings_laptop {
    # unmute and something else
    pacmd set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo no
    pacmd suspend-sink alsa_output.pci-0000_00_1b.0.analog-stereo no
    # source volume / sink volume, what's the difference?
    pacmd set-source-volume alsa_output.pci-0000_00_1b.0.analog-stereo.monitor 0x10000
    pacmd set-source-mute alsa_output.pci-0000_00_1b.0.analog-stereo.monitor no
    # turn down input (microphone)
    pacmd set-source-volume alsa_input.pci-0000_00_1b.0.analog-stereo 0x1456
    pacmd set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo yes
    pacmd suspend-source alsa_input.pci-0000_00_1b.0.analog-stereo no
}

function sensible_vol_headphones {
    # volume to 15%
    pacmd set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 0x266e
    sensible_settings_laptop
}

function sensible_vol_speakers {
    # volume to 30%
    pacmd set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 0x4cdc
    sensible_settings_laptop
}

function sensible_vol_woofer {
    # volume to 100%
    pacmd set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 0x10000
    sensible_settings_laptop
}

case "$1" in
    --HDMI)
        profile_HDMI
        ;;
    --HDMI-sensible)
        profile_HDMI
        sensible_vol_HDMI
        ;;
    --laptop)
        profile_laptop
        ;;
    --headphones-sensible)
        profile_laptop
        sensible_vol_headphones
        ;;
    --speakers-sensible)
        profile_laptop
        sensible_vol_speakers
        ;;
    --woofer-sensible)
        profile_laptop
        sensible_vol_woofer
        ;;
    --help)
        print_help
        ;;
    *)
        print_help
        exit 1
esac
