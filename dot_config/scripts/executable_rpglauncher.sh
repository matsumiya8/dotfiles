#!/bin/bash

GAME_DIR=$1
NWJS_BIN=$(command -v nw) || "$HOME/.local/share/nwjs/nw"

if [ ! -x "$NWJS_BIN" ]; then
    VER=$(curl -s https://nwjs.io/versions.json | jq -r '.stable')
    DL_URL="https://dl.nwjs.io/$VER/nwjs-$VER-linux-x64.tar.gz"
    NODE_FOLDER=$(dirname "$NWJS_BIN")
    mkdir -p "$NODE_FOLDER"
    notify-send -t 6000 "NW.js not found" "Downloading and unpacking, this may take a while"
    curl -fsSL "$DL_URL" | tar -xzf - -C "$NODE_FOLDER" --strip-components=1
fi

# Patching package.json with JQ if needed, it won't run if the name string is blank
jq '(if .name == "" then .name = "{}" else . end)' \
   "$GAME_DIR/package.json" > /tmp/package.json && mv /tmp/package.json "$GAME_DIR/package.json"

[[ ${XDG_CURRENT_DESKTOP,,} != "hyprland" ]] && $NWJS_BIN --user-data-dir=$HOME/.config/mv_games "$GAME_DIR" && exit

# Hyprland won't adjust the resolution properly, so we need to set it ourselves by digging it from the likely culprit
PLUGINS_FILE=$(find "$GAME_DIR" -name "plugins.js" -type f | head -1)

if [[ -f "$PLUGINS_FILE" ]]; then
	read WIDTH HEIGHT < <(
	  awk '
	    BEGIN { IGNORECASE=1 }
	    {
	      if (WIDTH==""  && match($0, /"screen[ _-]*width"[[:space:]]*:[[:space:]]*"?([0-9]+)"?/,  m)) WIDTH=m[1]
	      if (HEIGHT=="" && match($0, /"screen[ _-]*height"[[:space:]]*:[[:space:]]*"?([0-9]+)"?/, m)) HEIGHT=m[1]
	    }
	    END { print WIDTH, HEIGHT }
	  ' "$PLUGINS_FILE"
	)
    [[ -n $WIDTH ]] && WINDOWSIZE="size={$WIDTH,$HEIGHT}"
fi

ARGS="float = true, center = true, workspace = 1,$WINDOWSIZE"
hyprctl dispatch "hl.dsp.exec_cmd(\"$NWJS_BIN --user-data-dir=$HOME/.config/mv_games '$GAME_DIR'\",{$ARGS})"