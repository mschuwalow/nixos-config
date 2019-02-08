{ config, pkgs, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    apulse
    pavucontrol

    audacity
    ardour
    milkytracker
  ];

#  # Enable HDMI audio for pulse
#  hardware.pulseaudio.configFile = pkgs.stdenv.mkDerivation rec {
#    name = "pulseaudio-config";
#    buildCommand = ''
#      cat ${pkgs.pulseaudioFull}/etc/pulse/default.pa > $out
#      echo 'load-module module-alsa-sink device=hw:1,7' >> $out
#    '';
#  };
}
