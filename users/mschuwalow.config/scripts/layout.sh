#!/bin/bash

layout="$(setxkbmap -query | grep layout | sed 's/layout: *//' | awk '{print toupper($0)}')"
variant=" $(setxkbmap -query | grep variant | sed 's/variant: *//' | perl -ane ' foreach $wrd ( @F ) { print ucfirst($wrd)} print "\n"')"
echo -e "$layout$variant"

exit 0
