#!/bin/bash

IMAGE_PATH="/home/andrew/dotfiles/assets/image"
TICK_PATH="/home/andrew/.local/bin/marquee-tick"
CACHE_TITLE_PATH="/tmp/current-song-title"

SONG=$(playerctl metadata xesam:title)
INFO="$(playerctl metadata xesam:artist) 󰀥 $(playerctl metadata xesam:album)"

OLD_TITLE=$(cat $CACHE_TITLE_PATH 2>/dev/null)
if [ "$SONG" != "$OLD_TITLE" ]; then	
	IMAGE_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)
	if [ ! -z "$IMAGE_URL" ]; then
		(
			curl -s --output $IMAGE_PATH $IMAGE_URL 
			magick "$IMAGE_PATH" -resize 300x300^ -gravity center -extent 300x300 "$IMAGE_PATH"
		) &
	fi
	echo $SONG > $CACHE_TITLE_PATH
	echo 0 > $TICK_PATH
fi


#find visual length of string (chinese characters approximated to 2)
SONG_VISUAL_LENGTH=$(( ${#SONG} + $(echo "$SONG" | grep -P -o '\p{Han}' | wc -l) + 1))
INFO_VISUAL_LENGTH=$(( ${#INFO} + $(echo "$INFO" | grep -P -o '\p{Han}' | wc -l) + 1 ))
SONG_MAXCHAR=14
INFO_MAXCHAR=22
SONG_SEPARATOR="   󰝚   "
INFO_SEPARATOR="   󰎇   "

#marquee scroll animation
if [ $SONG_VISUAL_LENGTH -le $SONG_MAXCHAR ]; then
	SONG_MAXTICK=1
else
	SONG_MAXTICK=$(( ${#SONG} + ${#SONG_SEPARATOR}))
	SONG="${SONG}${SONG_SEPARATOR}${SONG}"
fi
if [ $INFO_VISUAL_LENGTH -le $INFO_MAXCHAR ]; then
	INFO_MAXTICK=1
else
	INFO_MAXTICK=$(( ${#INFO} + ${#INFO_SEPARATOR} ))
	INFO="${INFO}${INFO_SEPARATOR}${INFO}"
fi
TOTAL_TICKS=$(( SONG_MAXTICK * INFO_MAXTICK ))

CURR_TICK=$(cat $TICK_PATH 2>/dev/null)
[ -z "$CURR_TICK" ] && CURR_TICK=0
if [ $CURR_TICK -ge $TOTAL_TICKS ]; then
	CURR_TICK=0
fi
CURR_SONGTICK=$(( $CURR_TICK % $SONG_MAXTICK ))
CURR_INFOTICK=$(( $CURR_TICK % $INFO_MAXTICK ))

#construct marquee frame
SONG_LINE=""
VISUAL_LENGTH=0
OFFSET=0
while [ $VISUAL_LENGTH -lt $SONG_MAXCHAR ]
do
	NEW_SCHAR=${SONG:$(( $CURR_SONGTICK + $OFFSET )):1}
	SONG_LINE="${SONG_LINE}${NEW_SCHAR}"
	if echo $NEW_SCHAR | grep -P -q "\p{Han}"; then
		VISUAL_LENGTH=$(( $VISUAL_LENGTH + 2 ))
	else
		VISUAL_LENGTH=$(( $VISUAL_LENGTH + 1 ))
	fi
	OFFSET=$(( $OFFSET + 1 ))
done

INFO_LINE=""
VISUAL_LENGTH=0
OFFSET=0
while [ $VISUAL_LENGTH -lt $INFO_MAXCHAR ]
do
	NEW_ICHAR=${INFO:$(( $CURR_INFOTICK + $OFFSET )):1}
	INFO_LINE="${INFO_LINE}${NEW_ICHAR}"
	if echo $NEW_ICHAR | grep -P -q "\p{Han}"; then
		VISUAL_LENGTH=$(( $VISUAL_LENGTH + 2 ))
	else
		VISUAL_LENGTH=$(( $VISUAL_LENGTH + 1 ))
	fi
	OFFSET=$(( $OFFSET + 1 ))
done

if [ $CURR_TICK -eq $(( $TOTAL_TICKS - 1 )) ]; then
	echo 0 > $TICK_PATH
else
	echo $(( $CURR_TICK + 1 )) > $TICK_PATH
fi

#progressbar
POSITION=$(playerctl position | sed 's/\..*//')
UNIT=$(( $(playerctl metadata mpris:length) / 20000000 ))

if [ "$POSITION" -le $(( $UNIT * 1 )) ]; then
	PROGRESS_BAR="[O-------------------]"
elif [ "$POSITION" -le $(( $UNIT * 2 )) ]; then
	PROGRESS_BAR="[=O------------------]"
elif [ "$POSITION" -le $(( $UNIT * 3 )) ]; then
	PROGRESS_BAR="[==O-----------------]"
elif [ "$POSITION" -le $(( $UNIT * 4 )) ]; then
	PROGRESS_BAR="[===O----------------]"
elif [ "$POSITION" -le $(( $UNIT * 5 )) ]; then
	PROGRESS_BAR="[====O---------------]"
elif [ "$POSITION" -le $(( $UNIT * 6 )) ]; then
	PROGRESS_BAR="[=====O--------------]"
elif [ "$POSITION" -le $(( $UNIT * 7 )) ]; then
	PROGRESS_BAR="[======O-------------]"
elif [ "$POSITION" -le $(( $UNIT * 8 )) ]; then
	PROGRESS_BAR="[=======O------------]"
elif [ "$POSITION" -le $(( $UNIT * 9 )) ]; then
	PROGRESS_BAR="[========O-----------]"
elif [ "$POSITION" -le $(( $UNIT * 10 )) ]; then
	PROGRESS_BAR="[=========O----------]"
elif [ "$POSITION" -le $(( $UNIT * 11 )) ]; then
	PROGRESS_BAR="[==========O---------]"
elif [ "$POSITION" -le $(( $UNIT * 12 )) ]; then
	PROGRESS_BAR="[===========O--------]"
elif [ "$POSITION" -le $(( $UNIT * 13 )) ]; then
	PROGRESS_BAR="[============O-------]"
elif [ "$POSITION" -le $(( $UNIT * 14 )) ]; then
	PROGRESS_BAR="[=============O------]"
elif [ "$POSITION" -le $(( $UNIT * 15 )) ]; then
	PROGRESS_BAR="[==============O-----]"
elif [ "$POSITION" -le $(( $UNIT * 16 )) ]; then
	PROGRESS_BAR="[===============O----]"
elif [ "$POSITION" -le $(( $UNIT * 17 )) ]; then
	PROGRESS_BAR="[================O---]"
elif [ "$POSITION" -le $(( $UNIT * 18 )) ]; then
	PROGRESS_BAR="[=================O--]"
elif [ "$POSITION" -le $(( $UNIT * 19 )) ]; then
	PROGRESS_BAR="[==================O-]"
elif [ "$POSITION" -le $(( $UNIT * 20 )) ]; then
	PROGRESS_BAR="[===================O]"
else
	PROGRESS_BAR="[---------XX---------]"
fi

#buttons
STATUS=$(playerctl status)

if [ $STATUS == "Playing" ]; then
	BUTTONS="   [ 󰒮 ] [ 󰏤 ] [ 󰒭 ]"
else
	BUTTONS="   [ 󰒮 ] [ 󰐊 ] [ 󰒭 ]"
fi

echo -e "<span font='20'>$SONG_LINE</span>\n<span font='12'>$INFO_LINE</span>\n<span font='JetBrains Mono Nerd Font Propo 12'>$PROGRESS_BAR\n$BUTTONS</span>"
