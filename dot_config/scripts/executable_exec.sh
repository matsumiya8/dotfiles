#!/bin/bash
FILE_PATH="$1"
DIR_PATH=$(dirname "$FILE_PATH")
cd "$DIR_PATH" || exit 1
systemctl --user start fluidsynth.service
if [ -f "$DIR_PATH/package.json" ]; then
	"$HOME/.config/scripts/rpglauncher.sh" "$DIR_PATH"
elif [ -f "$DIR_PATH/resources/app.asar" ]; then
    ELECTRON=$(ls /bin/electron* | tail -n 1)
    [ -n $ELECTRON ] && hyprctl dispatch "hl.dsp.exec_cmd(\"$ELECTRON '$DIR_PATH/resources/app.asar'\", {float = true})"
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
