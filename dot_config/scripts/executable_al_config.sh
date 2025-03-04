#!/bin/bash

if pgrep -x "alarm.sh" > /dev/null; then
	if pidof -o %PPID -x "al_config.sh" > /dev/null; then
		pkill alarm.sh
		notify-send -t 2000 Notice "Alarm cancelled."
		exit
	fi
	
    current_time=$(date '+%s')
    start_time=$(date -d "$(ps -o lstart= -p $(pgrep -o alarm.sh))" '+%s')
    elapsed_time=$((current_time - start_time))
    hours=$((elapsed_time / 3600))
    minutes=$(( (elapsed_time % 3600) / 60 ))
    seconds=$((elapsed_time % 60))
    message="Run the script again within 5 seconds to cancel the ongoing alarm.\nElapsed time: "
    
    if [ $hours -gt 0 ]; then
        message+="<b>${hours}h ${minutes}m ${seconds}s</b>"
    elif [ $minutes -gt 0 ]; then
        message+="<b>${minutes}m ${seconds}s</b>"
    else
        message+="<b>${seconds}s</b>"
    fi
    notify-send -t 5000 Notice "$message"
    sleep 5
else
	if pidof -o %PPID -x "al_config.sh" > /dev/null; then
		notify-send "Another instance of the popup is already running!"
		exit
	fi
    islep=$(zenity --entry --entry-text "20m" --text "Enter duration:")
	$HOME/.config/scripts/alarm.sh "$islep" &
fi
