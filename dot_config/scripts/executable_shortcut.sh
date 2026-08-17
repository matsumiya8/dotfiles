#!/bin/bash

if [ -z "$1" ]; then
    zenity --error --text="No executable file provided.\nUsage: $0 /path/to/game.exe"
    exit 1
fi

EXE_PATH="$1"
EXE_DIR=$(dirname "$EXE_PATH")
ICON_OUTPUT_DIR="$HOME/.local/share/icons/exes"
DESKTOP_DIR="$HOME/.local/share/applications/games"

mkdir -p "$ICON_OUTPUT_DIR" "$DESKTOP_DIR"

GAME_NAME=$(zenity --entry --title="Create Game Shortcut" --text="Enter the name of the game:" --entry-text="$(basename "${EXE_PATH%.*}")")
[ -z "$GAME_NAME" ] && exit 0

SAFE_NAME=$(echo "$GAME_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
ICON_PATH="$ICON_OUTPUT_DIR/ge_${SAFE_NAME}.png"
DESKTOP_FILE="$DESKTOP_DIR/ge_${SAFE_NAME}.desktop"
TEMP_ICO=$(mktemp --suffix=.ico)
icoextract "$EXE_PATH" "$TEMP_ICO" && sleep 1

if [ -s "$TEMP_ICO" ]; then
    # Transparency fix & first item in the array is the largest icon usually
    convert "$TEMP_ICO[0]" -alpha on -background none -flatten "$ICON_PATH"
    rm "$TEMP_ICO"
else
    notify-send -t 3000 "Warning: No icon found in executable. Using generic icon."
    ICON_PATH="applications-games" 
fi

cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Type=Application
Name=$GAME_NAME
Comment=
Icon=$ICON_PATH
Exec="$EXE_PATH"
Path=$EXE_DIR
Terminal=false
Categories=Game;
StartupNotify=true
EOL

chmod +x "$DESKTOP_FILE" "$EXE_PATH"
notify-send -e -t 3000 "Shortcut" "Shortcut created successfully!\n\nName: $GAME_NAME\nLocation: $DESKTOP_FILE"
