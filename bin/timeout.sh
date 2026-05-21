#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: timeout <time>"
	exit 1
fi

if [[ ! $1 =~ ^-?[0-9]+$ ]]; then
	echo "Error: Time parameter must be an integer"
	exit 1
fi

sed -i 's/^\$TIMEOUT = .*/\$TIMEOUT = '"$1"'/' ~/.config/hypr/hypridle.conf
pkill hypridle && hypridle > /dev/null 2>&1 & disown

echo "Idle timeout successfully changed to $1 seconds"
exit 0

