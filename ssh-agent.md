SSH agent
=========

I had a hard time setting up automated ssh identity initialization.

Gnome keyring should work as an ssh agent (after setting up things in /etc/pam.d login and passwd),
but it did not (I am not using Gnome, but bringing up manually the keyring daemon is simple).
I already have a couple of Gnome libs, but no KDE and I'm not going to add that monstrosity for now
(so much for KWallet).

Keepass Keeagent is a nice idea, but it's AUR stuff plus I'm not going to type the password
for my kdb in, because that's huge. Also tried `envoy`, but it's focused on gpg stuff and the
pam part (pam_envoy) is not working.

So, **hackety hack** follows. Here be dragons, etc.

## 1. setup encryption

I use encfs (in `~/Private`), which is simple and straightforward; if you have LUKS, then
of course you don't need it.

## 2. setup .ssh directory

1. `.ssh` should symlink to `~/Private/.ssh`
2. id_rsa and friends should not be readable by group or other
3. create `id_rsa.secret` with plain text password (don't cry, it's not that bad)
4. have a `tmp` dir in Private (or use /dev/shm or /run/user/<uid>)

## 3. shellscript for passing the password to ssh-add

~/bin/ssh_addpass.sh

```bash
#!/bin/bash
pass=$(cat ~/.ssh/$1.secret)
pipe=~/Private/tmp/ps.sh

install -vm700 <(echo "echo $pass") $pipe > /dev/null
cat ~/.ssh/$1 | DISPLAY=:0.0 SSH_ASKPASS=$pipe ssh-add -
shred -u $pipe
```

* adapted from a stackoverflow post
* I could not make it work with `expect`
* DISPLAY is important: if you have no xserver running, SSH_ASKPASS will NOT work without it

## 4. start an ssh-agent (for the user) after login, shut it down at logout:

_.bash_profile_ is the interactive LOGIN shell for bash, its
parent is _/etc/profile_. It usually has one line sourcing _.bashrc_.

.bash_profile

```bash
# setup ssh agent
eval $(ssh-agent)
export SSH_AUTH_SOCK
~/bin/ssh_addpass.sh id_rsa
```

.bash_logout

```bash
# shutdown current ssh agent
ssh-agent -k
```
