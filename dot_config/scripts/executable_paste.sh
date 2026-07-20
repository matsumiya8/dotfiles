#!/bin/bash

FILE_EXT=$(wl-paste --list-types | grep -m 1 '^image/' | cut -d'/' -f2)
[[ -z "$FILE_EXT" ]] && exit
[[ -z "$1" ]] && exit
FILENAME=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 7; echo .$FILE_EXT)

wl-paste --type "image/$FILE_EXT" > "$1/$FILENAME"
