{ pkgs, ... }:
let

  self = pkgs.writeText "i3status.conf"
  ''
  separator=true
	separator_block_width=15

	[layout]
	label=  
	command=$HOME/scripts/layout.sh 
	interval=10
	signal=12

	[music-clementine]
	label=
	command=$HOME/scripts/music_clementine.sh
	interval=10

	[music-spotify]
	label=
	command=$HOME/scripts/music_spotify.sh
	interval=10

	[volume]
	label=
	command=$HOME/scripts/volume_control.py i3blocks
	interval=10
	signal=11
	markup=pango

	[brightness]
	label=
	command=echo "$($HOME/scripts/brightness.sh)%"
	interval=10
	signal=2

	[kbd_brightness]
	label=
	command=echo "$($HOME/scripts/kbd-brightness.py status)%"
	interval=10
	signal=5

	[temperature]
	label=
	command=echo "$($HOME/scripts/temperature.sh 'Core 0')°C"
	interval=5
	#border=#b16286

	[wireless]
	label=
	command=if [ -z "$(iwgetid -r)" ]; then echo "Wlan not connected"; else echo "$(iwgetid -r) - $(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"; fi
	interval=10

	[battery]
	command=$HOME/scripts/battery.sh
	interval=10

	[space_root]
	label=
	command=df -h --output=avail / | grep -v Avail
	interval=30

	[time]
	label=
	command=date '+%H:%M:%S %d/%m/%y'
	interval=1
	markup=pango
  '';

in
self
