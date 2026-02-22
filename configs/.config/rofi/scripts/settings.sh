#!/usr/bin/env bash

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
  echo "Audio"
  echo "Bluetooth"
  echo "Wifi"
  ;;
esac
