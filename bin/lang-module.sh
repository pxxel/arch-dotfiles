#!/bin/bash

CURRENT_LANG=$(fcitx5-remote -n 2>/dev/null)

case "$CURRENT_LANG" in
"keyboard-us")
	echo '{"text": "EN", "tooltip": "English (US)", "class": "keyboard-us"}'
	;;
"pinyin")
	echo '{"text": "拼", "tooltip": "中文 (简体)", "class": "pinyin"}'
	;;
esac
