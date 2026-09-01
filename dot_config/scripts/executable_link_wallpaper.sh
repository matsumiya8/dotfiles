#!/bin/bash
output="$1" workspace="$2"

if [ $# -ne 2 ]; then
    read -r output workspace < <(umbriel workspaces --json | jq --unbuffered -r '.[] | select(.focused) | "\(.output) \(.name)"')
fi

[ -z $workspace ] && exit 1

dest="$HOME/.cache/wallpapers/$workspace"
wallpaper=$(noctalia msg wallpaper-get $output)
[[ "$wallpaper" != "$dest" && "$wallpaper" != "$(readlink $dest)" ]] && {
	ln -sf "$wallpaper" "$dest"	
	notify-send -t 3000 -e "Wallpaper set" "Monitor: $output\nWorkspace: $workspace"
} || notify-send -t 2000 -e "Wallpaper matches previous entry" "No changes were made."
