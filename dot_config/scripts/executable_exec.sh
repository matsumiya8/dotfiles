#!/bin/bash
FILE_PATH="$1"
DIR_PATH=$(dirname "$FILE_PATH")
ELECTRON=$(compgen -c electron | sort -V | tail -n 1)
ELECTRON_FILE="$DIR_PATH/resources/app.asar"
GODOT_FILE=$(compgen -G "$DIR_PATH/*.pck")
SYSTEM35_FILE=$(compgen -G "$DIR_PATH/SYSTEM3*.EXE")

cd "$DIR_PATH" || exit 1
systemctl --user start fluidsynth.service

cleanup() {
    systemctl --user stop fluidsynth.service
    [ -n "$DISC" ] && cdemu unload 0
}

trap cleanup EXIT

launch() {
    LAUNCHER="$1"
    GAME="$2"
    case "${XDG_CURRENT_DESKTOP,,}" in
        "hyprland")
            ARGS="float = true, center = true, workspace = 1"
            hyprctl dispatch "hl.dsp.exec_cmd(\"$LAUNCHER '$GAME'\", {$ARGS})"
            ;;
        *)
            $LAUNCHER $GAME
            ;;
    esac
}

proton() {
    COMPATDIR="$HOME/.steam/steam/compatibilitytools.d"
    D7VK="0"
    DISC=""
    DLLOVERRIDES=""
    LOCALE="ja_JP.UTF-8"
    PREFIX="main"
    PROTON="Proton-GE Latest"
    WAYLAND="0"
    CONFIG_FILE="$DIR_PATH/proton.conf"
    [ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
    [ -n "$DISC" ] && cdemu load 0 "$DISC" 
    if [[ "${PROTON,,}" == "wine" ]]; then
        WINEDLLOVERRIDES="$DLLOVERRIDES" WINEPREFIX="$HOME/Games/umu/$PREFIX" LANG="$LOCALE" wine "$FILE_PATH"
    else
        GAMEID=$PREFIX PROTON_ENABLE_WAYLAND=$WAYLAND WINEDLLOVERRIDES="winepulse.drv=d;$DLLOVERRIDES" PROTON_USE_D7VK=$D7VK PROTONPATH="$COMPATDIR/$PROTON" LANG="$LOCALE" PRESSURE_VESSEL_FILESYSTEMS_RW=/storage umu-run "$FILE_PATH"
    fi
}

if [ -f "$DIR_PATH/package.json" ]; then
    "$HOME/.config/scripts/rpglauncher.sh" "$DIR_PATH"
elif [ -f "$ELECTRON_FILE" ] && [ -n $ELECTRON ]; then
    launch "$ELECTRON" "$ELECTRON_FILE"
elif [ -n "$GODOT_FILE" ] && [ -n "$(command -v godot)" ]; then
    launch "godot --main-pack" "$GODOT_FILE"
elif [ -n "$SYSTEM35_FILE" ] && [ -n "$(command -v xsystem35)" ]; then
    xsystem35
else
    proton
fi
