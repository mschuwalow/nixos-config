#!/usr/bin/env bash
set -eu

[[ -z "$(pgrep i3lock)" ]] || exit
i3lock -n -t -f -d -i ${HOME}/.config/i3lock/neutral-blue.png
