#!/bin/bash

LAST_PROFILE=$(powerprofilesctl get)

stdbuf -oL gdbus monitor --system --dest net.hadess.PowerProfiles --object-path /net/hadess/PowerProfiles | while read -r line; do
	if [[ "$line" == *"ActiveProfile"* ]]; then
		CURRENT_PROFILE=$(powerprofilesctl get)
		if [ "$CURRENT_PROFILE" != "$LAST_PROFILE" ]; then
			if [ "$CURRENT_PROFILE" = "performance" ]; then
				aplay -q /usr/share/sounds/my-sounds/avalon_trimmed.wav &
			else 
				pkill -f "aplay.*avalon_trimmed.wav"
			fi
			LAST_PROFILE="$CURRENT_PROFILE"
		fi
	fi
done
