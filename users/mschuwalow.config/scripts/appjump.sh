#!/bin/bash
class="$1"
prog="$2"
count=`ps aux | grep -c $prog`
echo $count
if [ $count -eq "3" ]; then
    exec "$prog"
else
    rofi -auto-select -show window -filter "$prog"
fi
# usage
# bindsym $mod+e exec ~/appjump.sh 'Emacs' emacs &
