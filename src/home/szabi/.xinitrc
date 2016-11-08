eval $(ssh-agent)
xrdb ~/.Xresources
setxkbmap hu

# detected with `xinput list` and `xinput list-props`
# 11 is the touchpad, 285 is drag lock bool, 286 is drag lock timeout (350ms)
xinput set-prop 11 285 1
xinput set-prop 11 286 350

exec startfluxbox
