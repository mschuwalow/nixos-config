#!/usr/bin/env bash

IFS=';' read updates security_updates < <(/usr/lib/update-notifier/apt-check 2>&1)

[[ "${updates}" = "0" ]] && exit 0

echo "  ${updates} - ${security_updates}"
pkill -RTMIN+3 i3blocks
exit 0
