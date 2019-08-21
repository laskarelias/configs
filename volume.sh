#!/bin/bash

function read_vol {
    vol=$(amixer -M sget Master | awk -F "[][]" '{print $2}' | grep -o '[0-9]\+')
}

function read_mute {
    mute=$(amixer sget Master | awk -F "[][]" '{print $6}' | grep o)
}

function up_vol {
    amixer set Master 2%+
}

function down_vol {
    amixer set Master 2%-
}

function mute_vol {
    amixer set Master toggle
}

function prep_display {
    read_vol
    read_mute
    bars=$(( vol / 5 ))
    if [[ $mute == "off" ]]; then
        vol_bar="x━━━━━━━━━━━━━━━━━━━"
    else
        for (( i=0; i<bars; i++ ))
            do
            vol_bar="${vol_bar}━"
        done

        if [[ $vol = 0 ]]; then
            vol_bar="${vol_bar}━"
        else
            vol_bar="${vol_bar}┃"
        fi

        for (( i=20; i>bars; i-- ))
            do
            vol_bar="${vol_bar}━"
        done
    fi
}

if [[ $1 == "up" ]]; then
    up_vol
elif [[ $1 == "down" ]]; then
    down_vol
elif [[ $1 == "mute" ]]; then
    mute_vol
fi

pkill sleep
pkill slstatus
prep_display
xsetroot -name "Volume: $vol_bar"
sleep 3
exec slstatus
