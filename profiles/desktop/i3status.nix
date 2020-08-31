{ pkgs, acpi, file, python3Packages, ... }:
let
  py3status = (python3Packages.py3status.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = [
      python3Packages.pytz
      python3Packages.tzlocal
      python3Packages.dbus-python
      python3Packages.setuptools
      file
      acpi
    ];
  }));

  configFile = pkgs.writeText "i3status.conf" ''
    # i3status configuration file.
    # see "man i3status" for documentation.

    # It is important that this file is edited as UTF-8.
    # The following line should contain a sharp s:
    # ß
    # If the above line is not correctly displayed, fix your editor first!

    general {
      interval = 5
      colors = true
      color_good = "#F9FAF9"
      color_bad = "#F9FAF9"
      color_degraded = "#DC322F"
    }

    order += "spotify"
    order += "net_rate"
    order += "whatismyip"
    order += "wireless _first_"
    order += "ethernet _first_"
    order += "load"
    order += "diskdata"
    order += "battery_level"
    order += "volume_status"
    order += "timer"
    order += "external_script"
    order += "tztime local"

    spotify {
      format = " {artist}: {title}"
      format_down = ""
      format_stopped = ""
    }

    timer {
      format = " {timer}"
      time = 3600
    }

    load {
      format = " %1min %5min %15min"
    }

    diskdata {
      prefix_type = decimal
      format = "⛁ {used_percent}% (U:{used} GB, F:{free} GB)"
    }

    external_script {
      format = "{output}"
      script_path = "cat /sys/class/tty/tty0/active"
    }

    whatismyip {
      format = " {isp}\|{city}\|{countryCode} ({ip})"
      icon_on = ""
      hide_when_offline = True
      url_geo = "http://ip-api.com/json"
    }

    wireless _first_ {
      format_up = " %essid (%ip)"
      format_down = ""
    }

    ethernet _first_ {
      format_up = " eth (%ip)"
      format_down = ""
    }

    net_rate {
      format_value = "[\?min_length=10 {value:.1f} {unit}]"
      si_units = "True"
      format = "{down}⇣ {up}⇡"
    }

    battery_level {
      battery_id = "all"
      cache_timeout = 30
      measurement_mode = "acpi"
      hide_when_full = "True"
      hide_seconds = "True"
      blocks = ""
      color_charging = "#00ff00"
      format = "{icon} {percent}% ({time_remaining})"
    }

    tztime local {
      format = "%d/%m %H:%M:%S"
    }
  '';
in "${py3status}/bin/py3status -c ${configFile}"
