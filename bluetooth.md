# Bluetooth

> Short version:
> forget it.

## Programmatically connecting to bluetooth devices

`bluetoothctl` is an interactive shell but it will also print
current bluetooth subsystem messages. It is NOT MEANT TO BE SCRIPTED.

Yes, one can echo commands into it, but it's a pain in the back,
since the "scan" process takes time and echoing magically a `sleep`
command is not going to cut it. Sometimes the scanning or the pairing
will fail, with no way to query the interface in a _sane_
scriptable fashion.

## Pairing a device

- Bluetooth devices love to power down, even if they are on constant juice.
- Laptops will happily kill the BT hardware during sleep (and they should)
- Both of these mean disconnections.

theoretically you would:

0. install bluez and bluez-utils
1. power on the device
2. launch bluetoothctl

```bluetoothctl
power on
scan on
trust 00:02:5B:00:XX:XX
pair 00:02:5B:00:XX:XX
connect 00:02:5B:00:XX:XX
quit
```

Unfortunately on my X230 when the machine returns from sleep the bluetooth
card craps itself and all subsequent connection attempts by external
devices will be dropped, `scan on` will not find a thing and it ends up in a limbo.

Disconnecting from the device and powering down the card before
closing the lid DOES NOT help.

## Bluetooth related error messages in journalctl

After spending an hour with bluetoothctl:

- `failed to execute '/usr/bin/hciconfig' '/usr/bin/hciconfig hci0 up': No such file or directory`  
  (yes, hciconfig is deprecated, beats me)
- `kernel: Bluetooth: Failed to register connection device`
- `bluetoothd[7032]: Endpoint replied with an error: org.bluez.Error.InvalidArguments`  
  (probably to pulseaudio query)
- `bluetoothd[7032]: Access denied: org.bluez.Error.Rejected`
  (around 50000 messages in the journal - yes, I have trusted the device, yes, bluetoothctl was running)
- `systemd-coredump[7459]: Process 7448 (bt-adapter) of user 1000 dumped core.`
- `bluetoothd[876]: a2dp-sink profile connect failed for 00:02:5B:00:61:D2: Device or resource busy`  
  (whoops, audio went away - this is a bluetooth speaker of course)
- `kernel: sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1a.0/usb1/1-1/...`  
  (yes, we might have hit a kernel bug)
