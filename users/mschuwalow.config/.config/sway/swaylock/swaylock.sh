#!/usr/bin/env bash
set -eu

[[ -z "$(pgrep swaylock)" ]] || exit
swaylock -t -i ${HOME}/.config/sway/swaylock/computer-lock.png
