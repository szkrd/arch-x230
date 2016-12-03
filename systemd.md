# Systemd (systemctl)

Has six units:

1. .service
2. .mount
3. .device
4. .socket
5. .target
6. .timer

Unit postfixes are attached magically for cetain types:

* whatever === whatever.service
* /home === home.mount
* /dev/sda === dev-sda.device
* @ = instance of a template unit

Check packaged units:
`pacman -Qql tlp | grep -Fe systemd/system`

Unit descriptors:

* /usr/lib/systemd/system/ →  installed by packages
* /etc/systemd/system/ → local (symlinks, folders, user saved unit files)

Systemctl (sctl) command:

* Sctl: status, cat, list-unit-files, start, stop, restart, reload, enable, reenable, is-enabled, disable, mask, unmask, help
* Sctl --failed
* Sctl demon-reload (after editing a unit file)

Disabling a service just removes its symlink from etc (so it may not start during boot), but it may still start as a dependency (from usr/lib/systemd/system). Use **mask** to redirect the symlink to /dev/null.

## Power management

* Polkit needed (1 user at TTY = good, 1+ = ask for permission)
* Sctl: `reboot`, `poweroff`, `suspend`, `hibernate`, `hybrid-sleep`

Certain actions may be needed on sleep start/stop (like wireless reinit or locking the screen, muting the audio). The `sleep.target` (see further below) will be called on all three states' changes (sleep, hibernate, hybrid).

## Editing

* Override locally (in etc?, not in usr lib)
* Shortcut: `systemctl edit --full unit` (this is a copy + edit + reenable combo), but of course this is a full static copy, no magic

## Targets

* `systemctl list-units --type=target`
* Targets are similar to sysv runlevels, but:
  * they are named (not numbered)
  * more than one may be active.
  * default target is **graphic** (~rl:5), while **multi-user** is like ~rl:3, and **rescue** is like ~rl:1
* It has runlevel-like targets predefined (so `telinit X` "kinda" works)
* Bootloader kernel param example: `systemd.unit=rescue.target`
* Or set default target (all the time): `systemctl set-default multi-user.target` (symlinks to default.target "somewhere", use -f to override)

Services may be linked to targets. Create a directory with __.wants__ postfix, for example: `ls /etc/systemd/system/sleep.target.wants/` has three files for me (two added manually, one symlinked by the system, as of this writing): `tlp-sleep.service  wicd-sleep.service  xlock.service`

## Temp files

Certain packages (x11, screen, sudo, samba etc.) read/write from/to in `/run` or `/var`. These environments are set up and torn down on demand.

* host tmp descriptors are in `/usr/lib/tmpfiles`, these are special .conf files (available commands are [here](https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html))
* linked (or devnulled) items are in `/etc/tmpfiles.d` 

## Timers

Timers are a bit like cron jobs, but are handled by systemd. The cron syntax is cleaner and simpler, and cron has access to the mailer daemon, but systemd offers greater control.

* there are systemd cron implementations
* `systemctl list-timers --all`
* a .timer file controls a .service file
* an example is [here](http://unix.stackexchange.com/questions/292444/using-systemd-timers-instead-of-cron), a generic battery check and hibernate combo

