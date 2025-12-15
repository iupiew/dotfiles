#!/bin/bash
current=$(setxkbmap -query | grep layout | awk '{print $2}' | cut -d',' -f1)
if [[ "$current" == *"us"* ]]; then
	setxkbmap ru
	notify-send "Layout: Russian"
else
	setxkbmap us
	notify-send "Layout: English"
fi
