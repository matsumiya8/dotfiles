#!/bin/bash
MONITOR="$1"
WORKSPACE="$2"
WALLPAPER=$(noctalia msg wallpaper-get $MONITOR)
DEST="$HOME/.cache/wallpapers/$WORKSPACE"
[[ "$WALLPAPER" != "$DEST" && "$WALLPAPER" != "$(readlink $DEST)" ]] && {
	ln -sf "$WALLPAPER" "$DEST"	
	notify-send -t 3000 -e "Wallpaper set" "Monitor: $MONITOR\nWorkspace: $WORKSPACE"
} || notify-send -t 2000 -e "Wallpaper matches previous entry" "No changes were made."
