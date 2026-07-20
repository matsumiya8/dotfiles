#!/bin/bash
dyn=~/.config/scripts/dyn
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
    	if [[ "${input:0:1}" == "/" ]]; then
    		$dyn artist "${input#/}"	
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
