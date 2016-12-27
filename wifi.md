Wireless networking
===================

## wpa_supplicant

wpa_supplicant (and wpa_supplicant_gui) are pretty straightforward, but they are pretty low level tools (though I remember using them back in my Arch days).

The main config is at `/etc/wpa_supplicant/wpa_supplicant.conf`, but that file is like a bildungsroman. Huge.

In theory `wpa_gui` should be able to manage this (??) config, though I could not make it work at all. First whines about "update_config=1" then says "Failed to enable network in wpa_supplicant configuration". Even if I have a working wifi using wpa_supplicant, the gui did not work at all.

### usage

* use `wpa_passphrase SSID passphrase > foo-bar.conf` to create a conf skeleton
* launch wpasupp in the bg with `wpa_supplicant -B -i wlp3s0 -c foo-bar.conf`
* obtain an IP address from the router with `dhcpcd wlp3s0`


### problems

* way too low level
* managing different profiles manually is painful
* gui is broken
* it's possible to launch multiple wpa_supplicant instances, that will result in an error (carrier timeout)

## wicd

Wicd is a bunch of python scripts (frontends fro wpa_supplicant); unfortunately `wicd-gtk` (the tray app) is downright useless, freezes all the time for me, locking one cpu core with 100% usage.

The cli frontend, `wicd-curses` is outdated (and way too buggy) in Arch, a patched one is available in AUR (`wicd-patched`). The patched one is quite stable.

Settings and passwords human readable at `/etc/wicd/wireless-settings.conf` (global conf); current ("running") config is at `/var/lib/wicd/configurations/`. These configs are managed by wicd tools.

* disconnect the wireless (-y) connection: `wicd-cli -x -y`
* connect: `wicd-cli -c -y -n $(wicd-cli -l -y | grep SSID | cut -c1-2)`

### sleep

Wicd needs to be restarted on wakeup. Suspending it during pre-sleep is nice, but it's not really neccessary.

Using `/etc/systemd/system/sleep.target.wants/wicd-sleep.service`:

```
[Unit]
Description=Wicd sleep hook
Before=sleep.target
StopWhenUnneeded=yes
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStop=-/usr/share/wicd/daemon/autoconnect.py
[Install]
WantedBy=sleep.target
```

### problems

* frontends are quite unstable
* very old, afaik unmaintained
* packet loss 100% upon wake up (rare, probably firmware level, not related to wicd)

## NetworkManager

Migrating from another network manager be sure to read the wpa_supplicant section above, that may be used as a fallback during the installation. Probably it is a good idea to add yourself to the network group (`ip a` and `ip link` are useful, ifconfig's gone).

1. `pacman -S networkmanager network-manager-applet gnome-keyring`
2. `systemctl enable NetworkManager.service && systemctl enable wpa_supplicant.service`
3. `systemctl disable dhcpcd.service && systemctl disable dhcpcd@.service && systemctl stop dhcpcd.service`
4. `ip link set down wlp3s0`
5. `systemctl start wpa_supplicant.service`
6. `systemctl start NetworkManager.service`
7. `Networkmanager`
8. add nm-applet to startup, use `nm-connection-editor` then test with `nm-applet`. Notifications will not work without gnome desktop or a notification daemon (like xfce4-notifyd).


### problems

* dependencies galore
* "wifi association took too long" error
* connections disappearing from nm-applet (only hidden and create are available)
* icon not updating (showing the computer icon or empty bars) after a long time

Packet loss
===========

I have constant problems with the intel wifi driver (iwlwifi). The latest microcode update was totally broken but the real problem is that sometimes the driver freaks out and I end up having 100% packet loss. This usually happens after sleep and very rarely after a reboot or cold start. This seems to be a problem with multiple Lenovo Thinkpads, though most people just restart NetworkManager and hoping for the best.

The journal shows no wireless related errors (the ones I had were connected to wicd, nm seems to be okay), routing table is fine, assigned ip is good, dns servers are okay.

So far turning off wifi power management helped (which is kinda tricky, because the driver will reset the value after waking up from a sleep):

## iwlwifi module settings

in /etc/modprobe.d/iwlwifi.conf (wireless N used to cause problems, so let's disable that too)

```
options iwlwifi 11n_disable=1
options iwlwifi power_save=0
```

## NetworkManager profiles

in /etc/NetworkManager/system-connections/SSID

```
[wifi]
mac-address=...
mac-address-blacklist=
mac-address-randomization=0
mode=infrastructure
seen-bssids=
ssid=SSID
powersave=0
```

## Advanced power management

in /etc/default/tlp

```
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=off
```
