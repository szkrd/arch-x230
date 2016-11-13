# https://wiki.archlinux.org/index.php?title=SSH_keys&redirect=no#Keychain
#keychain ~/.ssh/id_rsa
#[ -f ~/.keychain/$HOSTNAME-sh ] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null

xrdb ~/.Xresources
setxkbmap hu

# uses xbindskeyrc, window manager agnostic, but I 
# already have what I need in flux keys
#xbindkeys &

# detected with `xinput list` and `xinput list-props`
# 11 is the touchpad, 285 is drag lock bool, 286 is drag lock timeout (350ms)
xinput set-prop 11 285 1
xinput set-prop 11 286 350

exec startfluxbox
