#!/bin/bash
FILE_PATH="$1"
DIR_PATH=$(dirname "$FILE_PATH")
cd "$DIR_PATH" || exit 1
systemctl --user start fluidsynth.service
if [ -f "$DIR_PATH/package.json" ]; then
	"$HOME/.config/scripts/rpglauncher.sh" "$DIR_PATH"
else
	COMPATDIR="$HOME/.steam/steam/compatibilitytools.d"
	PREFIX="main"
	PROTON="GE-Proton11-1"
	LANGUAGE="ja_JP.UTF-8"
	WAYLAND=0
	DLLOVERRIDES=""
	DISC=""
	CONFIG_FILE="$DIR_PATH/proton.conf"
	[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
	[ -n "$DISC" ] && cdemu load 0 "$DISC" 
	if [[ "$PROTON" == "wine" ]]; then
		WINEDLLOVERRIDES="$DLLOVERRIDES" WINEPREFIX="$HOME/Games/umu/$PREFIX" LANG="$LANGUAGE" wine "$FILE_PATH"
	else
		GAMEID=$PREFIX PROTON_ENABLE_WAYLAND=$WAYLAND WINEDLLOVERRIDES="winepulse.drv=d;$DLLOVERRIDES" PROTON_USE_NTSYNC=1 PROTONPATH="$COMPATDIR/$PROTON" LANG="$LANGUAGE" STEAM_COMPAT_MOUNTS=/storage PRESSURE_VESSEL_FILESYSTEMS_RW=/storage umu-run "$FILE_PATH" & GAME_PID=$!
		wait $GAME_PID && sleep 1
    	pkill -9 -P "$GAME_PID" 2>/dev/null
    fi
    [ -n "$DISC" ] && cdemu unload 0
fi
systemctl --user stop fluidsynth.service
