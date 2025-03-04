#!/bin/bash

# Setting variables for the path to the games and nwjs
base_dir="$HOME/RPGMAKER/games"
nwjs_dir="$HOME/RPGMAKER/launcher"

# Showing each directory name in a wofi menu
selected_game=$(ls --quoting-style=literal $base_dir | walker -d)

# Checking whether or not a choice was made, and finding where the index.html of the game is
if [ -n "$selected_game" ]; then
  game_dir=$(find "$base_dir/$selected_game" -type f -name "index.html" -exec dirname {} \;)  
else
  notify-send -t 2000 "Aborting..."
  exit
fi

# Switching to the gaming workspace
hyprctl dispatch workspace 4

# Editing package.json if necessary and launching the game
jq 'if .name == "" then .name = "{}" else . end' "$game_dir/package.json" > /tmp/package.json && mv /tmp/package.json "$game_dir/package.json"
$nwjs_dir/nw --nwapp="$game_dir" --ozone-platform-hint=wayland
