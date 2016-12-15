#!/bin/bash
xdotool mousemove 0 0
synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
