#!/usr/bin/env bash

lock() {
    #  killall compton
    $HOME/.config/i3lock/i3lock.sh
    #  compton -b
}

case "$1" in
    lock)
        dm-tool lock
        ;;
    logout)
        i3-msg exit
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
