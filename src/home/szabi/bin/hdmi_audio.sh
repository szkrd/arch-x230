#!/usr/bin/env bash
case "$1" in
  "on")
    mv ~/.asoundrc.off ~/.asoundrc
    ;;
  "off")
    mv ~/.asoundrc ~/.asoundrc.off
    ;;
esac
alsactl restore
