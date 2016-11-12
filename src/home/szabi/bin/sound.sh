#!/bin/bash

# from:
# http://www.function.fr/advanced-linux-configuration-for-lenovo-thinkpad-x240/
# https://github.com/vvo/ansible-archee/blob/69c39f6d0f973265e4cb2917b318b5e36ea20cd5/roles/user/files/bin/sound.sh

# Configuration
STEP="5"    # Anything you like.  
UNIT="dB"   # dB, %, etc.

# Set volume
SETVOL="/usr/bin/amixer -qc 0 set Master"

case "$1" in  
    "up")
          $SETVOL $STEP$UNIT+
          ;;
  "down")
          $SETVOL $STEP$UNIT-
          ;;
  "mute")
          $SETVOL toggle
          ;;
esac

# Get current volume and state
VOLUME=$(amixer get Master | grep 'Mono:' | cut -d ' ' -f 6 | sed -e 's/[^0-9]//g')  
STATE=$(amixer get Master | grep 'Mono:' | grep -o "\[off\]")

# Show volume with volnoti
if [[ -n $STATE ]]; then  
  volnoti-show -m
else  
  volnoti-show $VOLUME
fi

exit 0
