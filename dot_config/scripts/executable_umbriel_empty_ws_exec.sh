#/bin/bash

workspace="$(umbriel workspaces --json | jq -r '.[] | select(.focused).id')"

[[ $workspace == $1 ]] && is_same_as_current=true || {
  is_same_as_current=false
  umbriel msg workspace-switch:"${1#*:}/${1%:*}" 
} 

windows=$(umbriel windows --json)
is_populated=$(jq --arg ws "$1" 'any(.[]; .workspace == $ws)' <<< "$windows")

case $1 in
    "DP-2:3") 
        ! $is_populated && zen-browser ;;
    "HDMI-A-1:3") 
        ! $is_populated && {
            launch=$(echo -e "rmpc\nSpotify" | noctalia dmenu -p "Select your music player")
            if [ $launch == "Spotify" ]; then
                spotify 
            elif [ $launch == "rmpc" ]; then
                kitty --class rmpc ~/.config/scripts/run_rmpc.sh &
            fi
        } || {
            ! $is_same_as_current && exit 0
            readarray -t workspace_windows < <(jq --arg ws "$1" -r '.[] | select(.workspace == $ws).app_id' <<< "$windows")
            if [[ ${workspace_windows[0]} == "spotify" ]]; then
                playerctl -p spotify pause
                (( ${#workspace_windows[@]} > 1 )) && umbriel msg window-focus-next && playerctl -p mpd play && exit
                kitty --class rmpc ~/.config/scripts/run_rmpc.sh &
            elif [[ ${workspace_windows[0]} == "rmpc" ]]; then
                playerctl -p mpd pause
                (( ${#workspace_windows[@]} > 1 )) && umbriel msg window-focus-next && playerctl -p spotify play && exit
                spotify
            fi
        } ;;
esac
