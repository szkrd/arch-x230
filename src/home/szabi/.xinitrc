# https://wiki.archlinux.org/index.php?title=SSH_keys&redirect=no#Keychain
#keychain ~/.ssh/id_rsa
#[ -f ~/.keychain/$HOSTNAME-sh ] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null

xrdb ~/.Xresources
setxkbmap hu

# uses xbindskeyrc, window manager agnostic, but I 
# already have what I need in flux keys
#xbindkeys &

# yes, kinda breaks
# compton -b

exec startfluxbox
