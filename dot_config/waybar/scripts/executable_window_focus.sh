#!/bin/bash

player=$(playerctl metadata --format '{{playerName}}')

case $player in
"cmus")
	hyprctl dispatch workspace 7 >/dev/null
	;;
"spotify")
	hyprctl dispatch workspace 8 >/dev/null
	;;
"smplayer")
	hyprctl dispatch focuswindow title:'SMPlayer' >/dev/null
	;;
esac
