#!/bin/bash
FILE_PATH="$1"
DIR_PATH=$(dirname "$FILE_PATH")
cd "$DIR_PATH" || exit 1
ARGS="float = true, center = true, workspace = 1"
ELECTRON=$(ls -v /bin/electron* | tail -n 1)
PCK_FILE=$(ls $DIR_PATH/*.pck)
systemctl --user start fluidsynth.service
if [ -f "$DIR_PATH/package.json" ]; then
	"$HOME/.config/scripts/rpglauncher.sh" "$DIR_PATH"
elif [ -n $ELECTRON ] && [ -f "$DIR_PATH/resources/app.asar" ]; then
    hyprctl dispatch "hl.dsp.exec_cmd(\"$ELECTRON '$DIR_PATH/resources/app.asar'\", {$ARGS})"
elif [ -f /bin/godot ] && [ -n "$PCK_FILE" ]; then
    hyprctl dispatch "hl.dsp.exec_cmd(\"godot --main-pack '$PCK_FILE'\", {$ARGS})"
else
	COMPATDIR="$HOME/.steam/steam/compatibilitytools.d"
	PREFIX="main"
	PROTON="Proton-GE Latest"
	LANGUAGE="ja_JP.UTF-8"
	WAYLAND="0"
	D7VK="0"
	DLLOVERRIDES=""
	DISC=""
	CONFIG_FILE="$DIR_PATH/proton.conf"
	[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
	[ -n "$DISC" ] && cdemu load 0 "$DISC" 
	if [[ "${PROTON,,}" == "wine" ]]; then
		WINEDLLOVERRIDES="$DLLOVERRIDES" WINEPREFIX="$HOME/Games/umu/$PREFIX" LANG="$LANGUAGE" wine "$FILE_PATH"
	else
		GAMEID=$PREFIX PROTON_ENABLE_WAYLAND=$WAYLAND WINEDLLOVERRIDES="winepulse.drv=d;$DLLOVERRIDES" PROTON_USE_D7VK=$D7VK PROTONPATH="$COMPATDIR/$PROTON" LANG="$LANGUAGE" STEAM_COMPAT_MOUNTS=/storage umu-run "$FILE_PATH"
    fi
    [ -n "$DISC" ] && cdemu unload 0
fi
systemctl --user stop fluidsynth.service
