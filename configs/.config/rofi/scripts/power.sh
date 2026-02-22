#!/usr/bin/env bash

ICON_DIR="$HOME/.assets/lucide/icons"

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
  echo -e "Lock\0icon\x1f$ICON_DIR/lock.svg"
  echo -e "Power off\0icon\x1f$ICON_DIR/power.svg"
  echo -e "Reboot\0icon\x1f$ICON_DIR/rotate-ccw.svg"
  echo -e "Suspend\0icon\x1f$ICON_DIR/pause.svg"
  echo -e "Log out\0icon\x1f$ICON_DIR/log-out.svg"
  ;;
esac
