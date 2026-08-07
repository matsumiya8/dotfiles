#!/bin/bash

nwjs_bin="$HOME/.local/share/nwjs/nw"
game_dir=$1
plugins_file=$(find "$game_dir" -name "plugins.js" -type f | head -1)

# Hyprland won't adjust the resolution properly, so we need to set it ourselves. Starting by digging it from the resizing plugin file
if [[ -f "$plugins_file" ]]; then
	read WIDTH HEIGHT < <(
	  awk '
	    BEGIN { IGNORECASE=1 }
	    {
	      if (WIDTH==""  && match($0, /"screen[ _-]*width"[[:space:]]*:[[:space:]]*"?([0-9]+)"?/,  m)) WIDTH=m[1]
	      if (HEIGHT=="" && match($0, /"screen[ _-]*height"[[:space:]]*:[[:space:]]*"?([0-9]+)"?/, m)) HEIGHT=m[1]
	    }
	    END { print WIDTH, HEIGHT }
	  ' "$plugins_file"
	)
fi

# If we can't find the resolution from plugins.js, read it from package.json (only accurate if the plugin didn't override it)
if [ -z "$WIDTH" ]; then
	IFS=$'\n' read -d '' WIDTH HEIGHT < <(jq '.window.width, .window.height' "$game_dir/package.json")
fi

# Patching package.json with JQ if needed, it won't run if the name string is blank
jq '(if .name == "" then .name = "{}" else . end)' \
   "$game_dir/package.json" > /tmp/package.json && mv /tmp/package.json "$game_dir/package.json"

hyprctl dispatch "hl.dsp.exec_cmd(\"$nwjs_bin --user-data-dir=$HOME/.config/mv_games '$game_dir'\",{float=true, center=true, workspace=1, size={$WIDTH, $HEIGHT}})"
