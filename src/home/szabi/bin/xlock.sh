#!/usr/bin/env bash
if ! xset q &>/dev/null; then
    vlock
    exit 0
fi
xlock -startCmd zapoff.sh -endCmd zapon.sh
