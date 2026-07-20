#!/bin/bash

if pgrep -x "sunshine" >/dev/null; then
	xrandr --output DP-2 --primary
	hyprctl output remove SUNSHINE
	pkill -x "sunshine"
	pkill -x "antimicrox"
	notify-send -e -t 2000 "Sunshine" "Stopped streaming"
	exit
fi

hyprctl output create headless SUNSHINE; sleep 1
xrandr --output SUNSHINE --primary
notify-send -e -t 2000 "Sunshine" "Started streaming"
antimicrox --tray & sunshine &
