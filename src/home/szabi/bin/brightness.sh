#!/bin/bash

STEP="10"    # Anything you like.

# Set volume
INC="/usr/bin/xbacklight -inc"  
DEC="/usr/bin/xbacklight -dec"

case "$1" in  
  "up")
          $INC $STEP
          ;;
  "down")
          $DEC $STEP
          ;;
esac
