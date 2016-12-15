#!/bin/bash
case "$1" in
  "up")
    ponymix increase 10
    ;;
  "down")
    ponymix decrease 10
    ;;
  "toggle")
    ponymix toggle
    ;;
esac
STATE=$(ponymix | grep -o Muted)
VOLUME=$(current_volume.sh)
if [[ -n $STATE ]]; then
  volnoti-show -m
else
  volnoti-show $VOLUME
fi
exit 0
