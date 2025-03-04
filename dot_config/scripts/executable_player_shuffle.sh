#!/bin/bash

shuffle=$(playerctl -p playerctld shuffle)

if [[ $shuffle == "Off" ]]; then
	playerctl -p playerctld shuffle toggle	
	notify-send -t 2000 "SHUFFLE: ENABLED"
else
	playerctl -p playerctld shuffle toggle
	notify-send -t 2000 "SHUFFLE: DISABLED"
fi
