#!/bin/bash
cd "$HOME/.config/scripts/music"
dyn=./dyn
active=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == '8' and .visible == true).class')
[[ "$active" == "spotify" ]] && {
    mode=$1
    id=$(playerctl --player=spotify metadata mpris:trackid)
    [ -z $mode ] && {
        mode="playlist" id="0dc7fzzqZlbck2WXf5N5bz"
    } || {
        id=$(python3 $HOME/.config/scripts/music/spoti_aaa.py $mode ${id##*/})
    }
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri string:spotify:$mode:$id
    exit
}

[[ "$active" != "rmpc" ]] && exit

case "$1" in
    "artist")
        artist=$(mpc -f %artist% current)
        $dyn artist exact $artist
        ;;
    "album")
        album=$(mpc -f %album% current)
        $dyn album exact $album
        ;;
    "input")
        bind 'Tab: self-insert'
        bind '"\e": "\C-a\C-k\n""'
        IFS= read -r -e input || exit; [[ -z $input ]] && exit
        if [[ "${input:0:1}" == "[" ]]; then
            $dyn artist "${input#[}"	
        elif [[ "${input:0:1}" == $'\t' ]]; then
            sed -E 's/\t([^\t]+)/ any "\1"/g' <<< "$input" | xargs bash -c 'mpc search "$@" | mpc insert' _
            exit
        else
            $dyn album $input
        fi 
        ;;
    "")
        $dyn reset
        ;;
    *)
        echo "Usage: $0 [artist|album|input]"
        exit 1
        ;;
esac

if ! pgrep -x "dyn" > /dev/null; then
	hyprctl dispatch exec "$dyn start 44"
fi

mpc crop || mpc clear
