#!/usr/bin/env bash
mv ~/.asoundrc ~/.asoundrc.off
alsactl restore
