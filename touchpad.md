Touchpad
========

Synaptics and evdev are going away, things must be reconfigured for **libinput**.
_xf86-input-libinput_ is probably already around and installed, synaptics
just took precedence.

1. `pacman -Rcs xf86-input-synaptics xf86-input-evdev`
2. move away _XX-synaptics.conf_ in /etc/X11/xorg.conf.d
3. restart x
4. try to double tap with touchpad, realize it's not working, be sad

Check device id:
`ID=$(xinput list | grep Synaptics | grep -o -E "id=[0-9]+" | grep -o -E "[0-9]+")`

List of possible settings for runtime configuration:
`xinput list-props $ID`

Fox X create libinput settings: `ne /etc/X11/xorg.conf.d/10-libinput.conf`
and check the xorg [libinput man page](https://www.mankier.com/4/libinput) for a list of props.

Unfortunately synclient had much much more options, but so it goes. The touchpad
on the x230 is a piece of crap anyway, so no real harm done.

```xorg
Section "InputClass"
  Identifier      "touchpad"
  MatchProduct    "SynPS/2 Synaptics TouchPad"
  Driver          "libinput"
  Option          "Tapping" "true"
  Option          "TappingDrag" "true"
  Option          "DisableWhileTyping" "true"
  Option          "HorizontalScrolling" "false"
  Option          "ScrollMethod" "twofinger"
EndSection
```
/etc/X11/xorg.conf.d/10-libinput.conf (END)

## Toggle the touchpad

The palm detection is useless, so I usually have a shortcut key assigned
in fluxbox to disable the touchpad while I write longer texts.

```bash
#!/bin/bash
xdotool mousemove 0 0
ID=$(xinput list | grep Synaptics | grep -o -E "id=[0-9]+" | grep -o -E "[0-9]+")
STATE=$(xinput list-props $ID | grep "Device Enabled" | grep --color=never -o -E "\\s[01]" | awk '{$1=$1};1')
if [ $STATE == "0" ]; then STATE=1; else STATE=0; fi;
xinput set-prop $ID "Device Enabled" $STATE
```

## Legacy

An example synaptics configuration (NOT usable with libinput of course):

```
Section "InputClass"
        Identifier "touchpad"
        MatchProduct "SynPS/2 Synaptics TouchPad"
        Driver "synaptics"
        Option "VertResolution" "100"
        Option "HorizResolution" "65"
        Option "MinSpeed" "1"
        Option "MaxSpeed" "1"
        Option "AccelerationProfile" "2"
        Option "AdaptiveDeceleration" "8"
        Option "ConstantDeceleration" "8"
        Option "VelocityScale" "32"
        #Option "AccelerationNumerator" "30"
        #Option "AccelerationDenominator" "10"
        #Option "AccelerationThreshold" "10"
        Option "TapButton2" "0"
        Option "TapButton1" "1"
        Option "HorizHysteresis" "100"
        Option "VertHysteresis" "100"
        Option "VertScrollDelta" "500"
        Option "CoastingSpeed" "5"
        Option "MaxTapTime" "250"
        Option "MaxTapMove" "800"
        Option "LockedDrags" "1"
        Option "LockedDragTimeout" "350"
        Option "PalmDetect" "1"
        Option "PalmMinWidth" "8"
        Option "PalmMinZ" "100"
EndSection
```
/etc/X11/xorg.conf.d/50-synaptics.conf (END)
