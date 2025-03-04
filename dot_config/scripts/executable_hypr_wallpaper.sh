#!/bin/bash

wallpapers=(
"-o DP-2 /home/pyne/.wallpapers/pics/aruruu.jpg"
"-o DP-2 /home/pyne/.wallpapers/pics/3:3.jpg"
"-o DP-2 /home/pyne/.wallpapers/pics/2:2.jpg"
"-o DP-2 /home/pyne/.wallpapers/pics/wall_sk.jpg"
"-o DVI-D-1 /home/pyne/.wallpapers/pics/5:I.jpg"
"-o DVI-D-1 /home/pyne/.wallpapers/pics/7:III.jpg"
"-o DVI-D-1 /home/pyne/.wallpapers/pics/6:II.jpg"
"-o DVI-D-1 /home/pyne/.wallpapers/pics/8:.jpg"
)

function handle {
	if [[ ${1:0:9} == "workspace" ]]; then
		swww img ${wallpapers[${line: -1} -1]} --transition-type simple --transition-step 20
	fi
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done

