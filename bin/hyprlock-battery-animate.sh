#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/BAT0"
CACHE_PATH="/tmp/hyprlock-battery-cache"

NOW=$(date +%s)

if [ -f "%CACHE_PATH" ] && [ $(( $NOW - $(stat -c %Y "%CACHE_PATH") )) -lt 2 ]; then
	read -r STATUS CAPACITY < "$CACHE_PATH"
else
	STATUS=$(cat "$BATTERY_PATH/status")
	CAPACITY=$(cat "$BATTERY_PATH/capacity")
	echo "$STATUS $CAPACITY" > "$CACHE_PATH"
fi

TICK=$(( $(date +%s%2N) % 200 ))


	if [ "$STATUS" = "Charging" ]; then
		color="#7afffc"
		if [ $TICK -le 19 ]; then
				frame="󰂄 [░░░░░░░░░]"
		elif [ $TICK -le 39 ]; then
            			frame="󰂄 [▓░░░░░░░░]"
		elif [ $TICK -le 59 ]; then
            			frame="󰂄 [▓▓░░░░░░░]"
		elif [ $TICK -le 79 ]; then
				frame="󰂄 [▓▓▓░░░░░░]"
		elif [ $TICK -le 99 ]; then
				frame="󰂄 [▓▓▓▓░░░░░]"
		elif [ $TICK -le 119 ]; then
				frame="󰂄 [▓▓▓▓▓░░░░]"
		elif [ $TICK -le 139 ]; then
				frame="󰂄 [▓▓▓▓▓▓░░░]"
		elif [ $TICK -le 159 ]; then
				frame="󰂄 [▓▓▓▓▓▓▓░░]"
		elif [ $TICK -le 179 ]; then
				frame="󰂄 [▓▓▓▓▓▓▓▓░]"
			else
				frame="󰂄 [▓▓▓▓▓▓▓▓▓]"
		fi
		echo "<span foreground='$color'>$frame $CAPACITY%</span>"
	else
		if [ $CAPACITY -le 10 ]; then 
			ICON="󰁺 [░░░░░░░░░]"
			CLASS="critical"
			color="#f53c3c"
		elif [ $CAPACITY -le 20 ]; then 
			ICON="󰁻 [▓░░░░░░░░]"
			CLASS="low"
			color="#f57a3c"
		elif [ $CAPACITY -le 30 ]; then 
			ICON="󰁼 [▓▓░░░░░░░]"
			CLASS="low"
			color="#f57a3c"
		elif [ $CAPACITY -le 40 ]; then 
			ICON="󰁽 [▓▓▓░░░░░░]"
			CLASS="meh"
			color="#f2d974"
		elif [ $CAPACITY -le 50 ]; then 
			ICON="󰁾 [▓▓▓▓░░░░░]"
			CLASS="meh"
			color="#f2d974"
		elif [ $CAPACITY -le 60 ]; then 
			ICON="󰁿 [▓▓▓▓▓░░░░]"
			CLASS="medium"
			color="#5aff82"
		elif [ $CAPACITY -le 70 ]; then 
			ICON="󰂀 [▓▓▓▓▓▓░░░]"
			CLASS="medium"
			color="#5aff82"
		elif [ $CAPACITY -le 80 ]; then 
			ICON="󰂁 [▓▓▓▓▓▓▓░░]"
			CLASS="high"
			color="#5affb9"
		elif [ $CAPACITY -le 90 ]; then 
			ICON="󰂂 [▓▓▓▓▓▓▓▓░]"
			CLASS="high"
			color="#5affb9"
		else 
			ICON="󰁹 [▓▓▓▓▓▓▓▓▓]"
		        CLASS="high"
			color="#5affb9"	
		fi

		echo "<span foreground='$color'>$ICON $CAPACITY%</span>"
	fi
