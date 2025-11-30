#!/bin/bash

wallpaper_dir="$HOME/Pictures/Wallpapers/"
swww_args="--transition-type simple --transition-step 20"

declare -a wallpapers=()
while IFS= read -r -d '' file; do
	wallpapers+=("-o $(basename $(dirname $file)) $file")
done < <(find $wallpaper_dir -type f -print0)

function handle {
    if [[ ${1:0:9} == "workspace" ]]; then
        swww img ${wallpapers[${1: -1} -1]} $swww_args
    fi
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done

