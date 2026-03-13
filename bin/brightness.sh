#!/bin/bash
# Get current brightness
ICON="$HOME/.config/dunst/icons/brightness-white.svg"
brillo=$(brightnessctl g)
max=$(brightnessctl m)
percent=$((100 * brillo / max))

# Perform action (up or down)
if [ "$1" == "up" ]; then
  brightnessctl s +5%
elif [ "$1" == "down" ]; then
  brightnessctl s 5%-
fi

# Send notification via Dunst
# Update this line in your script
dunstify -a "system" -u low -i "$ICON" -h string:x-dunst-stack-tag:brightness -h int:value:"$percent" "Brightness: $percent%"
