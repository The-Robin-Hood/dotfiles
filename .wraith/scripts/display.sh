#!/usr/bin/env sh

SOURCE=$(printf "DP-1\nHDMI-1\nHDMI-2" |rofi -dmenu -i -theme $HOME/.wraith/theme/scripts.rofi.rasi -theme-str 'listview {lines:4;}')
[ -z "$SOURCE" ] && exit 0

case "$SOURCE" in
  DP-1)   ddcutil setvcp 60 0x0f ;;
  HDMI-1) ddcutil setvcp 60 0x11 ;;
  HDMI-2) ddcutil setvcp 60 0x12 ;;
esac