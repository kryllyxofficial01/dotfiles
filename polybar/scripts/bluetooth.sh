#!/bin/bash

echo -n "%{F#F0C674}BT%{F-} "

if ! bluetoothctl show | grep -q "Powered: yes"; then
    echo -n "%{F#707880}off%{F-}"
    exit 0
fi

device=$(bluetoothctl info | grep "Name: " | cut -d " " -f2-)

if [ -n "$device" ]; then
    echo -n "$device"
else
    echo -n "%{F#ff0000}X%{F-}"
fi
