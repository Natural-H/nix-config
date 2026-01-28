#!/run/current-system/sw/bin/bash

killall -9 .waybar-wrapped
killall -9 .swaync-wrapped

waybar &
swaync &

