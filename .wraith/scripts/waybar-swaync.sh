#!/bin/zsh

killall waybar
killall swaync

waybar &
swaync &
