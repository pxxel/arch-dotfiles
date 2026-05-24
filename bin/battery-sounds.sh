#!/bin/bash

THRESHOLD=10
CRITICAL_AUDIO_PATH="/usr/share/sounds/my-sounds/battery-critical.wav"
CHARGING_AUDIO_PATH="/usr/share/sounds/my-sounds/battery-charging.wav"

CRITICAL_STATE_FILE="/tmp/battery-critical-sound-played"
CHARGING_STATE_FILE="/tmp/battery-charging-sound-played"

while true; do
	CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
	STATUS=$(cat /sys/class/power_supply/AC/online)

	if [ "$STATUS" -eq 0 ]; then
		if [ -f "$CHARGING_STATE_FILE" ]; then
			rm -f "$CHARGING_STATE_FILE"
		fi
		if [ "$CAPACITY" -le "$THRESHOLD" ]; then
			if [ ! -f "$CRITICAL_STATE_FILE" ]; then
				aplay -q "$CRITICAL_AUDIO_PATH"
				touch "$CRITICAL_STATE_FILE"
			fi
		fi
	elif [ "$STATUS" -eq 1 ]; then
		if [ -f "$CRITICAL_STATE_FILE" ]; then
			rm -f "$CRITICAL_STATE_FILE"
		fi
		if [ ! -f "$CHARGING_STATE_FILE" ]; then
			aplay -q "$CHARGING_AUDIO_PATH"
			touch "$CHARGING_STATE_FILE"
		fi
	fi
	sleep 2
done

