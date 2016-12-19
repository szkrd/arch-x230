#!/usr/bin/env bash
WLDEVCOUNT=$(ls -1 /sys/class/net | grep wl --color=never | wc -l)
if [ $WLDEVCOUNT -eq 1 ]
then
  WLINTERFACE=$(ls -1 /sys/class/net | grep wl --color=never)
  echo "Operating on interface '$WLINTERFACE'."
else
  echo "Could not determine your wireless interface, sorry."
  exit 1
fi
# ----
NIU=0
while [ $NIU -eq 0 ]
do
  echo "Polling interface for UP."
  NIU=$(ip a | grep $WLINTERFACE | grep UP | wc -l)
  sleep 2
done
# ----
if [ $(nmcli -t -c no -f state g) == 'connected' ]
then
  echo "Wireless state is connected"
else
  echo "Wreless is not connected, I will not ping the router now. Bye."
  exit 1
fi
# ----
ROUTERIP=`ip route | grep $WLINTERFACE | sed 's/default via //' | sed 's/ .*//' | head -n 1`
echo "Network is up, checking for packet loss at $ROUTERIP."
PLOSS=$(ping -c 3 -w 2 $ROUTERIP | grep "100% packet loss" | wc -l)
if [ $PLOSS -eq 1 ]
then
  echo "Oh, crap :( Disconnecting and reconnecting, please wait a bit."
  nmcli r wifi off && nmcli r wifi on
else
  echo "Everything is cool."
fi
