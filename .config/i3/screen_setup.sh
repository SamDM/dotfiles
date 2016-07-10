#!/usr/bin/env bash

# Helper script to setup the displays in a few configurations I commonly use.
# To easily make the xrandr commands, install and use the `arandr` program to
# choose a setup and export the settings to a file. The file content is the
# command to set the chosen setup.

# If the HDMI is connected, enable both screens, if not, only the laptop screen
function setup_auto {
    CONNECTED_DISPLAYS=$(xrandr | grep -e ' connected ' | cut -d' ' -f1)
    HDMI1_CONNECTED=$(echo $CONNECTED_DISPLAYS | grep -c 'HDMI1')

    if [[ $HDMI1_CONNECTED == 1 ]]; then
        setup_desk
    else
        setup_laptop
    fi
}

function setup_laptop {
    xrandr                    \
        --output HDMI1        \
            --off             \
        --output LVDS1        \
            --primary         \
            --mode 1366x768   \
            --pos 0x0         \
            --rotate normal   \
        --output VIRTUAL1     \
            --off             \
        --output DP1          \
            --off             \
        --output VGA1         \
            --off
}

function setup_theatre {
    xrandr                    \
        --output HDMI1        \
            --primary         \
            --mode 1920x1080  \
            --pos 0x0         \
            --rotate normal   \
        --output LVDS1        \
            --off             \
        --output VIRTUAL1     \
            --off             \
        --output DP1          \
            --off             \
        --output VGA1         \
            --off
}

function setup_desk {
    xrandr                    \
        --output HDMI1        \
            --primary         \
            --mode 1920x1080  \
            --pos 1366x0      \
            --rotate normal   \
        --output LVDS1        \
            --mode 1366x768   \
            --pos 0x0         \
            --rotate normal   \
        --output VIRTUAL1     \
            --off             \
        --output DP1          \
            --off             \
        --output VGA1         \
            --off
}

case  $1  in
    --auto)
        setup_auto
        ;;
    --laptop)
        setup_laptop
        ;;
    --theatre)
        setup_theatre
        ;;
    --desk)
        setup_desk
        ;;
    *)
        echo invalid option
        exit 1
        ;;
esac
