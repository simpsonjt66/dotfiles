#!/bin/sh
# Times the screen off and puts it to background
swayide \
  timeout 10 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on "' &
#Locks the screen immediately
swaylock -c 000000
# Kills last background task so idle timer doesn't keey running
kill %%
