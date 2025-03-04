#!/bin/env bash

imagefile="/tmp/sloppy.$RANDOM.png"
text="/tmp/translation"
echo "$imagefile"
slurp=$(slurp -f "%wx%h+%x+%y") || exit 1
read -r G <<< $slurp
import -window root -crop $G $imagefile
tesseract $imagefile $text -l jpn -c preserve_interword_spaces=1 2>/dev/null 
kitty --hold sdcv --data-dir /home/pyne/.config/stardict/ -n $(cat $text".txt") | less
