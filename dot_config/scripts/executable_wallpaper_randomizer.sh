#!/bin/zsh
base_folder="$HOME/Pictures/Wallpapers"
dest_folder="/home/pyne/.cache/wallpapers"
for dir count in "DP-2" 5 "HDMI-A-1" 4; do
    for file in ${(f)"$(find "$base_folder/$dir" -type f | shuf -n $count)"}; do
        ln -sf "$file" "$dest_folder/$((++i))"
    done
done
notify-send -t 2000 -e "Wallpaper Randomizer" "Sucess"
