{ pkgs, python3Packages, file, ... }:
let
  py3status = (python3Packages.py3status.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = [
      python3Packages.pytz
      python3Packages.tzlocal
      python3Packages.dbus-python
      python3Packages.setuptools
      file
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
      colors = true
      interval = 5
      color_good = "#F9FAF9"
      color_bad = "#F9FAF9"
      color_degraded = "#DC322F"
    }

    order += "spotify"
    order += "net_rate"
    order += "whatismyip"
    order += "wireless _first_"
    order += "ethernet _first_"
    # order += "load"
    order += "cpu_usage"
    #order += "disk /"
    order += "diskdata"
    #order += "battery all"
    order += "battery_level"
    # order += "load"
    order += "volume_status"
    order += "timer"
    order += "external_script"
    order += "tztime local"
    # order += "ipv6"

    spotify {
      format = "  {artist}: {title}"
      format_down = ""
      format_stopped = ""
    }

    timer {
      format = "  {timer}"
      time = 3600
    }

    cpu_usage {
      format = "  %usage"
    }

    load {
      format = "load %1min"
      # max_threshold = 0.3
    }

    diskdata {
      prefix_type = decimal
        #format_space = "[\?min_length=5 {value:.2f}]"
      format = " ⛁ {used_percent}% (U:{used} GB, F:{free} GB) "
    }

    external_script {
      format = "{output}"
      script_path = "cat /sys/class/tty/tty0/active"
    }

    whatismyip {
      format = "  {isp}\|{city}\|{countryCode} ({ip})"
      icon_on = ""
      hide_when_offline = True
      url_geo = "http://ip-api.com/json"
    }

    wireless _first_ {
      format_up = "  %essid (%ip)"
      format_down = ""
    }

    ethernet _first_ {
      format_up = "  eth (%ip)"
      format_down = ""
    }

    net_rate {
      format_value = "[\?min_length=10 {value:.1f} {unit}]"
      si_units = "True"
      format = "{down}⇣ {up}⇡"
    }

    battery all {
      # format = "%status %percentage %remaining %emptytime"
      format = " %status %percentage %remaining "
      format_down = "No battery"
      last_full_capacity = true
      integer_battery_capacity = true
      status_chr = ""
      status_bat = "⚡"
      status_unk = "?"
      status_full = "☻"
      low_threshold = 15
      threshold_type = time
    }

    battery_level {
      cache_timeout = 30
      measurement_mode = "acpi"
      hide_when_full = "True"
      hide_seconds = "True"
      blocks = ""
      color_charging = "#00ff00"
      format = " {icon} {percent}% ({time_remaining})"
    }

    tztime local {
      format = "%d/%m %H:%M:%S"
    }
  '';
in "${py3status}/bin/py3status -c ${configFile}"
