#!/bin/sh
qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | egrep "albumArtist|title" | awk -F": " '{ if ($1 == "xesam:albumArtist") { a = $2 } if ($1 == "xesam:title") { print a " - " $2 } }'
