#!/bin/bash

# Setting variables for the path to the games and nwjs
base_dir="$HOME/RPGMAKER/games"
nwjs_bin="$HOME/nwjs/nw"

# Showing each directory name in a wofi menu
if [ "$#" -eq 0 ]; then
	selected_game=$(ls --quoting-style=literal $base_dir | walker -d)

# Checking whether or not a choice was made, and finding where the index.html of the game is
	if [ -n "$selected_game" ]; then
  		game_dir=$(find "$base_dir/$selected_game" -type f -name "index.html" -exec dirname {} \;)
	else
 	 	notify-send -t 2000 "Aborting..."
  		exit
	fi
else
	game_dir=$1
fi
plugins_file=$(find "$game_dir" -name "plugins.js" -type f | head -1)
if [[ -z "$plugins_file" ]] || [[ ! -f "$plugins_file" ]]; then
    echo "plugins.js not found -- sourcing resolution from package.json"
else
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

if [ -z "$WIDTH" ]; then
	echo "nah"
	IFS=$'\n' read -d '' WIDTH HEIGHT < <(jq '.window.width, .window.height' "$game_dir/package.json")
fi

# Patching package.json with JQ if necessary
jq '(if .name == "" then .name = "{}" else . end)' \
   "$game_dir/package.json" > /tmp/package.json && mv /tmp/package.json "$game_dir/package.json"
export LANG=ja_JP.UTF-8

#hyprctl dispatch -- exec "[float; vrr 0; center; workspace 1; size $WIDTH $HEIGHT]" "$nwjs_dir/nw --user-data-dir=$HOME/.config/mv_games '$game_dir'"
final_dir="\"$game_dir\""
hyprctl dispatch "hl.dsp.exec_cmd(\"$nwjs_bin --user-data-dir=$HOME/.config/mv_games $game_dir\",{float=true, center=true, workspace=1, size={$WIDTH, $HEIGHT}})"
