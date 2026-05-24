#!/bin/bash

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
	if [[ "$line" == workspace\>\>* ]] then
		ws="${line#workspace>>}"
		if  [[ "$ws" =~ ^[0-9]+$ ]]; then
			pkill -f "^aplay.*/my-sounds/layer-[0-9]"
			aplay -q "/usr/share/sounds/my-sounds/layer-${ws}.wav" &
		fi
	fi
done

