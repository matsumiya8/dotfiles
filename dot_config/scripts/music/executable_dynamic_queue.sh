#!/bin/bash
mode=$1
dyn="$HOME/.config/scripts/music/dyn"
mpd_status=$(playerctl -p mpd status)
active=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == '8' and .visible == true).class')
[[ "$active" == "spotify" && $mpd_status  != "Playing" && $mode != "input" ]] && {
    playerctl --all-players pause
    id=$(playerctl --player=spotify metadata mpris:trackid)
    [ -z $mode ] && {
        mode="playlist" id="0dc7fzzqZlbck2WXf5N5bz"
    } || {
        id=$(python3 $HOME/.config/scripts/music/spoti_actions.py print_$mode\_id ${id##*/})
    }
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri string:spotify:$mode:$id
    exit
}

case "$mode" in
    "artist")
        artist=$(mpc -f %artist% current)
        $dyn artist exact "$artist"
        ;;
    "album")
        album=$(mpc -f %album% current)
        $dyn album exact $album
        ;;
    "input")
    bind '"\e": "\C-a\C-k\n"'
    IFS= read -r -e input || exit
    [[ -z "$input" ]] && exit
    if [[ "$input" == /* ]]; then
        "$dyn" artist "${input#/}"
    else
        "$dyn" album "$input"
    fi
    ;;
    "")
        $dyn reset
        ;;
esac

if ! pgrep -x "dyn" > /dev/null; then
	hyprctl dispatch exec "$dyn start 44"
fi

mpc crop || mpc clear

[[ $mpd_status != "Playing" ]] && {
    playerctl --all-players pause
    playerctl -p mpd next
}

