#!/bin/bash
FILE_PATH="$1"
FILE_ARGS="${@:2}"
DOTS_URL="https://raw.githubusercontent.com/matsumiya8/dotfiles/refs/heads/main/dot_config"
DIR_PATH=$(dirname "$FILE_PATH")
ELECTRON=$(compgen -c electron | sort -V | tail -n 1)
ELECTRON_FILE="$DIR_PATH/resources/app.asar"
GODOT_FILE=$(compgen -G "$DIR_PATH/*.pck")
SYSTEM35_FILE=$(compgen -G "$DIR_PATH/SYSTEM3*.EXE")
RPGLAUNCHER="$HOME/.config/scripts/rpglauncher.sh"
DEFAULTCONFIG="$HOME/.config/proton.conf"
GAMECONFIG="$DIR_PATH/proton.conf"
RPGMV_FILE="$DIR_PATH/package.json"
RPG2000_FILE="$DIR_PATH/RPG_RT.ini"

cd "$DIR_PATH" || exit 1
systemctl --user start fluidsynth.service

cleanup() {
    [ -n "$DISC" ] && cdemu unload 0
    systemctl --user stop fluidsynth.service
    [ -n "$JOYPROFILE" ] && pgrep -x antimicrox && pkill -x antimicrox
}

launch() {
    LAUNCHER="$1" GAME="$2"
    case "${XDG_CURRENT_DESKTOP,,}" in
        "hyprland")
            HYPR_ARGS="float = true, center = true, workspace = 1"
            hyprctl dispatch "hl.dsp.exec_cmd(\"$LAUNCHER '$GAME'\", {$HYPR_ARGS})"
            ;;
        *)
            $LAUNCHER $GAME
            ;;
    esac
}

download_if_missing() {
    FILE="$1" URL="$2"
    [ -f "$FILE" ] || {
        notify-send -t 4000 "Exec" "$(basename "$FILE") is missing, fetching from GitHub"
        mkdir -p "$(dirname $FILE)"
        curl -L -o "$FILE" "$URL" || {
            notify-send -t 4000 "Exec" "Download failed! Aborting..."
            exit 1
        }
    }
}

check_var_and_command() {
    VAR="$1" CMD="$2" REQ="$3"
    [[ -z "$VAR" || "$VAR" == "0" || "${VAR,,}" == "none" ]] && return 1
    ! command -v "$CMD" >/dev/null && {
        notify-send -t 6000 "Exec" "Warning: $REQ requested by proton.conf but $CMD is not installed"
        return 1
    } 
    return 0
}

proton() { 
    download_if_missing "$DEFAULTCONFIG" "$DOTS_URL/proton.conf"
    source "$DEFAULTCONFIG" && source "$GAMECONFIG"
    COMPATDIR="${COMPATDIR%/}/" PREFIXDIR="${PREFIXDIR%/}/" JOYPROFILEDIR="${JOYPROFILEDIR/}/"
    DLLOVERRIDES="${DEFAULTOVERRIDES%;:+$DEFAULTOVERRIDES;}$GAMEOVERRIDES"
    [ ! "$(command -v umu-run)" ] && {
        [ "$(command -v wine)" ] || {
            notify-send -t 6000 "Exec" "No wine or umu-run found in path. Aborting..." 
            exit 1
        }
        notify-send -t 6000 "Exec" "umu-run not found, using wine instead."
        PROTON="wine"
    }
    check_var_and_command "$DISC" "cdemu" "DISC" && cdemu load 0 "$DISC" || DISC=""
    check_var_and_command "$FPSCAP" "mangohud" "FPSCAP" && MANGOHUDENV="env MANGOHUD_CONFIG=fps_limit=$FPSCAP,no_display mangohud"
    check_var_and_command "$JOYPROFILE" "antimicrox" "JOYPROFILE" && antimicrox --hidden --profile "$JOYPROFILEDIR$JOYPROFILE" &
    [ -z "$PROTON" ] && PROTON="$DEFAULTPROTON"
    [ "${PROTON,,}" == "wine" ] && {
        WINEDLLOVERRIDES="$DLLOVERRIDES" WINEPREFIX="$PREFIXDIR$PREFIX" LANG="$LOCALE" $MANGOHUDENV wine "$FILE_PATH" $FILE_ARGS
        exit 0
    }
    [ -d "$COMPATDIR$PROTON" ] || {
        [ -d "$COMPATDIR$DEFAULTPROTON" ] && PROTON="$DEFAULTPROTON" || {
            notify-send -t 6000 "Exec" "No configured Proton available. Downloading GE-Proton. Edit your \"$DEFAULTCONFIG\""
            COMPATDIR="" PROTON="GE-Proton"
        }
    }
    GAMEID=$PREFIX UMU_RUNTIME_UPDATE=$RUNTIMEUPDATE UMU_HTTP_TIMEOUT=1 PROTONFIXES_DISABLE=$NOFIXES PROTON_ENABLE_WAYLAND=$WAYLAND WINEDLLOVERRIDES="$DLLOVERRIDES" PROTON_USE_D7VK=$D7VK PROTONPATH="$COMPATDIR$PROTON" LANG="$LOCALE" PRESSURE_VESSEL_FILESYSTEMS_RW="$RWDIRS" $MANGOHUDENV umu-run "$FILE_PATH" $FILE_ARGS
    exit 0
}

trap cleanup EXIT

[ -f "$GAMECONFIG" ] && proton "$DIR_PATH"

if [ -f "$RPGMV_FILE" ]; then
    download_if_missing "$RPGLAUNCHER" "$DOTS_URL/scripts/executable_rpglauncher.sh"
    "$RPGLAUNCHER" "$DIR_PATH"
elif [ -f "$RPG2000_FILE" ] && [ -n "$(command -v easyrpg-player)" ]; then
    easyrpg-player
elif [ -f "$ELECTRON_FILE" ] && [ -n $ELECTRON ]; then
    launch "$ELECTRON" "$ELECTRON_FILE"
elif [ -n "$GODOT_FILE" ] && [ -n "$(command -v godot)" ]; then
    launch "godot --display-driver wayland --main-pack" "$GODOT_FILE"
elif [ -n "$SYSTEM35_FILE" ] && [ -n "$(command -v xsystem35)" ]; then
    xsystem35 -fullscreen
else
    proton "$DIR_PATH"
fi