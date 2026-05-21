#!/bin/bash

brightnessctl -s -q

CUR_BRIGHTNESS=$(brightnessctl get -q)

while [ $CUR_BRIGHTNESS -ge 10 ]; do
	brightnessctl set 10%- -q
	CUR_BRIGHTNESS=$(brightnessctl get -q)
	sleep 0.03
done

exit 0
