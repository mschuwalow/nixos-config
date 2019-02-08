#!/bin/bash

case "$1" in
    new)
        i3-msg workspace $(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        ;;
    move)
        workspace=$(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        i3-msg move container to workspace $workspace
        i3-msg workspace $workspace
        ;;
    *)
        echo "Usage: $0 [new|move]"
        exit 2
esac

exit 0
