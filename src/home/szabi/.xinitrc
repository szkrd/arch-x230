if pgrep ssh-agent>/dev/null;
  then echo "ssh-agent running";
  else eval $(ssh-agent);
fi

## use gnome keyring as an ssh agent (after setting up thins in /etc/pam.d login and passwd)
## yep, tecnically it should work, but it does not :(
#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK

xrdb ~/.Xresources
setxkbmap hu

# uses xbindskeyrc, window manager agnostic, but I 
# already have what I need in flux keys
#xbindkeys &

# yes, kinda breaks
# compton -b

dropboxd &

exec startfluxbox
