#!/usr/bin/env bash

ICON_DIR="$HOME/.assets/lucide/icons"

case "$1" in
"Audio")
  hyprctl dispatch exec '[float; center; size 1200 900] kitty -e impala' >/dev/null 2>&1
  ;;
"Bluetooth")
  hyprctl dispatch exec '[float; center; size 1200 900] kitty -e bluetui' >/dev/null 2>&1
  ;;
"Wifi")
  hyprctl dispatch exec '[float; center; size 1200 900] kitty -e wiremix --tab output' >/dev/null 2>&1
  ;;
*)
  echo -e "Audio\0icon\x1f$ICON_DIR/volume-2.svg"
  echo -e "Bluetooth\0icon\x1f$ICON_DIR/bluetooth.svg"
  echo -e "Wifi\0icon\x1f$ICON_DIR/wifi.svg"
  ;;
esac
