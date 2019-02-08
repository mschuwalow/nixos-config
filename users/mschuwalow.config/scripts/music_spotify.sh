#! /bin/bash

msg=$(sp metadata | grep --color=never -E '^albumArtist|^title' | sed 's/[^|]*|//' | awk -vORS=' >> ' 'y {print s} {s=$0;y=1} END {ORS=""; print s}')

if [ -n "$msg" ]
then 
	echo "$msg"
else
	exit 1
fi