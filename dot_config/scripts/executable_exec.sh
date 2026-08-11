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

cd "$DIR_PATH" || exit 1
systemctl --user start fluidsynth.service

cleanup() {
    [ -n "$DISC" ] && cdemu unload 0
    systemctl --user stop fluidsynth.service
}

launch() {
    LAUNCHER="$1"
    GAME="$2"
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
    FILE="$1"
    URL="$2"
    [ -f "$FILE" ] || {
        notify-send -t 4000 "Exec" "$(basename "$FILE") is missing, fetching from GitHub"
        mkdir -p "$(dirname $FILE)"
        curl -L -o "$FILE" "$URL" || {
            notify-send -t 4000 "Exec" "Download failed! Aborting..."
            exit 1
        }
    }
}

proton() { 
    download_if_missing "$DEFAULTCONFIG" "$DOTS_URL/proton.conf"
    source "$DEFAULTCONFIG" && source "$GAMECONFIG"
    COMPATDIR="${COMPATDIR%/}/" PREFIXDIR="${PREFIXDIR%/}/"
    DLLOVERRIDES="${DEFAULTOVERRIDES%;:+$DEFAULTOVERRIDES;}$GAMEOVERRIDES"
    [ ! "$(command -v umu-run)" ] && {
        [ "$(command -v wine)" ] || {
            notify-send -t 6000 "Exec" "No wine or umu-run found in path. Aborting..." 
            exit 1
        }
        notify-send -t 6000 "Exec" "umu-run not found, using wine instead."
        PROTON="wine"
    }
    [ -n "$DISC" ] && {
        [ "$(command -v cdemu)" ] && cdemu load 0 "$DISC" || {
            notify-send -t 6000 "Exec" "Warning: Disc requested by proton.conf but cdemu is not installed"
            DISC=""
        }
    } 
    [ -z "$PROTON" ] && PROTON="$DEFAULTPROTON"
    [ "${PROTON,,}" == "wine" ] && {
        WINEDLLOVERRIDES="$DLLOVERRIDES" WINEPREFIX="$PREFIXDIR$PREFIX" LANG="$LOCALE" wine "$FILE_PATH" $FILE_ARGS
        exit 0
    }
    [ -d "$COMPATDIR$PROTON" ] || {
        [ -d "$COMPATDIR$DEFAULTPROTON" ] && PROTON="$DEFAULTPROTON" || {
            notify-send -t 6000 "Exec" "No configured Proton available. Downloading GE-Proton. Edit your \"$DEFAULTCONFIG\""
            COMPATDIR="" PROTON="GE-Proton"
        }
    }
    GAMEID=$PREFIX UMU_RUNTIME_UPDATE=$RUNTIMEUPDATE UMU_HTTP_TIMEOUT=1 PROTONFIXES_DISABLE=$NOFIXES PROTON_ENABLE_WAYLAND=$WAYLAND WINEDLLOVERRIDES="$DLLOVERRIDES" PROTON_USE_D7VK=$D7VK PROTONPATH="$COMPATDIR$PROTON" LANG="$LOCALE" PRESSURE_VESSEL_FILESYSTEMS_RW="$RWDIRS" umu-run "$FILE_PATH" $FILE_ARGS
    exit 0
}

trap cleanup EXIT

if [ -f "$DIR_PATH/package.json" ]; then
    download_if_missing "$RPGLAUNCHER" "$DOTS_URL/scripts/executable_rpglauncher.sh"
    "$RPGLAUNCHER" "$DIR_PATH"
elif [ -f "$ELECTRON_FILE" ] && [ -n $ELECTRON ]; then
    launch "$ELECTRON" "$ELECTRON_FILE"
elif [ -n "$GODOT_FILE" ] && [ -n "$(command -v godot)" ]; then
    launch "godot --main-pack" "$GODOT_FILE"
elif [ -n "$SYSTEM35_FILE" ] && [ -n "$(command -v xsystem35)" ]; then
    xsystem35
else
    proton "$DIR_PATH"
fi