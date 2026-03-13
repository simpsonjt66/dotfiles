#!/bin/bash

# Use wpctl (WirePlumber) to adjust volume
case "$1" in
up)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0
  ;;
down)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  ;;
mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  ;;
esac

# Get volume percentage and mute status
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "\[MUTED\]")

# Choose icon based on state
if [ -n "$is_muted" ]; then
  icon="$HOME/.config/dunst/icons/volume-muted-white.svg"
  label="Muted"
else
  icon="$HOME/.config/dunst/icons/volume-white.svg"
  label="Volume: ${volume}%"
fi

# Send notification (reusing your brightness logic)
dunstify -a "system" -u low -i "$icon" -h string:x-dunst-stack-tag:volume -h int:value:"$volume" "$label"
