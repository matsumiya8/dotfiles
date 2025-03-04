#!/bin/bash
b2 upload-file matsumiya $1 ${1##*/}
success=$?
if [ $success -ne 0 ]; then
	notify-send -t 2000 "Upload unsuccessful"
	exit
fi
result=https://f002.backblazeb2.com/file/matsumiya/${1##*/}
echo $result | wl-copy
notify-send -t 2000 'Upload finished' $result; play /usr/share/sounds/freedesktop/stereo/complete.oga
