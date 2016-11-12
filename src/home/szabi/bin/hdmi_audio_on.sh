#!/usr/bin/env bash
mv ~/.asoundrc.off ~/.asoundrc
alsactl restore
