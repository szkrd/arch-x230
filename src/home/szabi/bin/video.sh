#!/usr/bin/env bash
case "$1" in
  "vga")
    xrandr --output LVDS1 --auto --output HDMI1 --off
    ;;
  "hdmi-simple")
    xrandr --output LVDS1 --off --output HDMI1 --auto
    ;;
  "hdmi")
    xrandr --output LVDS1 --auto --output HDMI1 --off && xrandr --output LVDS1 --off --output HDMI1 --auto && pkill conky && sleep 1 && conky -d
    ;;
  "both")
    xrandr --output LVDS1 --auto --output HDMI1 --auto
    ;;
  "list-connected")
    xrandr | grep -E --color=never 'connected|disconnected' | sed 's/cted.*/cted/' | sed 's/disconnected//' | sort
    ;;
esac
