#!/bin/bash

case "$1" in
    new)
        swaymsg workspace $(($(swaymsg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        ;;
    move)
        workspace=$(($(swaymsg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        swaymsg move container to workspace $workspace
        swaymsg workspace $workspace
        ;;
    *)
        echo "Usage: $0 [new|move]"
        exit 2
esac

exit 0
