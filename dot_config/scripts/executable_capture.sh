#!/bin/bash
SS_FOLDER="/bog/Screenshots/$(date +%Y-%m)"
FILENAME="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 7; echo)"
killall -SIGINT -q gpu-screen-recorder && exit 0
gpu-screen-recorder -w $1 -f 60 -k av1 -a default_output -o "/tmp/$FILENAME.mp4" && {
	zenity --question --text="Upload?" || { rm -f "/tmp/$FILENAME.mp4"; exit; }
	cp "/tmp/$FILENAME.mp4" "$SS_FOLDER" & sleep 0.5
	rclone copy "/tmp/$FILENAME.mp4" pynes_stuff:uploads
	if [ $? -eq 0 ]; then
		notify-send -e -t 2000 'Uploader' 'Link copied to the clipboard!'
		wl-copy "https://u.pyne.top/$FILENAME.mp4"
	else
		notify-send -e -t 2000 "Uploader" "Upload failed\nError:$?"
	fi
}
fi
