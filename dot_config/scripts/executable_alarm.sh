#!/bin/bash

sleep $1

if [ $? -eq 0 ]; then
	hyprctl dispatch exec "zenity --warning --text='Tis time'" & play /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
else
	notify-send -t 2000 "Input error"
fi
