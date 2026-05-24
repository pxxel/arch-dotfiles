#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/BAT0"

while true; do
	STATUS=$(cat "$BATTERY_PATH/status")
	CAPACITY=$(cat "$BATTERY_PATH/capacity")

	if [ "$STATUS" = "Charging" ]; then
		frames=(
			"󰂄 [░░░░░░░░░]"
            		"󰂄 [▓░░░░░░░░]"
            		"󰂄 [▓▓░░░░░░░]"
            		"󰂄 [▓▓▓░░░░░░]"
            		"󰂄 [▓▓▓▓░░░░░]"
            		"󰂄 [▓▓▓▓▓░░░░]"
            		"󰂄 [▓▓▓▓▓▓░░░]"
            		"󰂄 [▓▓▓▓▓▓▓░░]"
            		"󰂄 [▓▓▓▓▓▓▓▓░]"
            		"󰂄 [▓▓▓▓▓▓▓▓▓]"
		)
		for frame in "${frames[@]}"; do
			if [ "$(cat "$BATTERY_PATH/status")" != "Charging" ]; then break; fi

			echo "{\"text\": \"$frame $CAPACITY%\", \"class\": \"charging\"}"
			sleep 0.2
		done
	else
		if [ $CAPACITY -le 10 ]; then 
			ICON="󰁺 [░░░░░░░░░]"
			CLASS="critical"
		elif [ $CAPACITY -le 20 ]; then 
			ICON="󰁻 [▓░░░░░░░░]"
			CLASS="low"
		elif [ $CAPACITY -le 30 ]; then 
			ICON="󰁼 [▓▓░░░░░░░]"
			CLASS="low"
		elif [ $CAPACITY -le 40 ]; then 
			ICON="󰁽 [▓▓▓░░░░░░]"
			CLASS="meh"
		elif [ $CAPACITY -le 50 ]; then 
			ICON="󰁾 [▓▓▓▓░░░░░]"
			CLASS="meh"
		elif [ $CAPACITY -le 60 ]; then 
			ICON="󰁿 [▓▓▓▓▓░░░░]"
			CLASS="medium"
		elif [ $CAPACITY -le 70 ]; then 
			ICON="󰂀 [▓▓▓▓▓▓░░░]"
			CLASS="medium"
		elif [ $CAPACITY -le 80 ]; then 
			ICON="󰂁 [▓▓▓▓▓▓▓░░]"
			CLASS="high"
		elif [ $CAPACITY -le 90 ]; then 
			ICON="󰂂 [▓▓▓▓▓▓▓▓░]"
			CLASS="high"
		else 
			ICON="󰁹 [▓▓▓▓▓▓▓▓▓]"
		        CLASS="high"	
		fi

		echo "{\"text\": \"$ICON $CAPACITY%\", \"class\": \"$CLASS\"}"
		sleep 1
	fi
done
