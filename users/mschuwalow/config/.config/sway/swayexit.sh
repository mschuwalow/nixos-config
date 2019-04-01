#!/usr/bin/env bash

lock() {
    #  killall compton
    $HOME/.config/sway/swaylock/swaylock.sh
    #  compton -b
}

case "$1" in
    lock)
        lock
        ;;
    suspend)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 [lock|suspend|hibernate|reboot|shutdown]"
        exit 2
esac

exit 0
