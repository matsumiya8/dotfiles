#!/bin/bash
FILERINO=$(echo $1 | tr -d "'")
rclone copy "$FILERINO" pynes_stuff:uploads
success=$?
if [ $success -ne 0 ]; then
	notify-send -t 2000 "Upload unsuccessful"
	exit
fi
result=https://u.pyne.top/${FILERINO##*/}
wl-copy "$result"
notify-send -e -t 2000 'Upload finished' $result
