#!/usr/bin/env bash

case "$1" in
"Lock")
  hyprlock >/dev/null 2>&1
  ;;
"Power off")
  systemctl poweroff >/dev/null 2>&1
  ;;
"Reboot")
  systemctl reboot >/dev/null 2>&1
  ;;
"Suspend")
  systemctl suspend >/dev/null 2>&1
  ;;
"Log out")
  hyprctl dispatch exit >/dev/null 2>&1
  ;;
*)
  echo "Lock"
  echo "Power off"
  echo "Reboot"
  echo "Suspend"
  echo "Log out"
  ;;
esac
