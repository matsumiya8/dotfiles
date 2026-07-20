#!/bin/bash

# Check if an argument was provided
if [ -z "$1" ]; then
    zenity --error --text="No executable file provided.\nUsage: $0 /path/to/game.exe"
    exit 1
fi

EXE_PATH=$(echo $1 | tr -d "'")
EXE_DIR=$(dirname "$EXE_PATH")
ICON_OUTPUT_DIR="$HOME/.local/share/icons/exes/"

# Ensure the icon directory exists
mkdir -p "$ICON_OUTPUT_DIR"

GAME_NAME=$(zenity --entry --title="Create Game Shortcut" --text="Enter the name of the game:" --entry-text="$(basename "${EXE_PATH%.*}")")

# Check if user clicked Cancel or provided empty input
if [ -z "$GAME_NAME" ]; then
    echo "Operation cancelled by user."
    exit 0
fi

# Removes everything except alphanumeric characters and converts to lowercase
SAFE_NAME=$(echo "$GAME_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')

# Define paths
ICON_PATH="$ICON_OUTPUT_DIR/ge_${SAFE_NAME}.png"
DESKTOP_FILE="$HOME/.local/share/applications/ge_${SAFE_NAME}.desktop"

# Extract and convert the icon
echo "Attempting to extract icon from $EXE_PATH..."

# Create a temporary file for the raw icon
TEMP_ICO=$(mktemp --suffix=.ico)

# Extract the first icon group found in the exe to the temp file
icoextract "$EXE_PATH" "$TEMP_ICO" && sleep 1

# Check if extraction resulted in a valid file
if [ -s "$TEMP_ICO" ]; then
    convert "$TEMP_ICO[0]" -alpha on -background none -flatten "$ICON_PATH"
    rm "$TEMP_ICO"
else
    notify-send -t 2000 "Warning: No icon found in executable. Using generic icon."
    ICON_PATH="applications-games" 
fi

# Create the .desktop file
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

# Make it executable, notify and refresh the database
chmod +x "$DESKTOP_FILE"
[ -x "EXE_PATH" ] || chmod +x "$EXE_PATH"
notify-send -e -t 2000 "Shortcut" "Shortcut created successfully!\n\nName: $GAME_NAME\nLocation: $DESKTOP_FILE"
update-desktop-database "$HOME/.local/share/applications" &> /dev/null
