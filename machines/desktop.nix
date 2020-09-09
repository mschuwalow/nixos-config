{ config, pkgs, ... }:

{
  networking.hostName = "mschuwalow-desktop";
  time.hardwareClockInLocalTime = true;

  boot.kernelParams = [ "idle=nomwait" ];
  services.xserver = {
    displayManager.sessionCommands = ''
      xrandr \
      --output HDMI-0 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --mode 1920x1080 --pos 3640x0 --rotate right \
      --output DP-0 --primary --mode 2560x1440 --pos 1080x0 --rotate normal \
      --output DP-1 --off \
      --output DP-2 --off \
      --output DP-3 --off \
      --output DP-4 --mode 1920x1080 --pos 0x0 --rotate left \
      --output DP-5 --off
    '';
    videoDrivers = [ "nvidia" ];
  };

  system.stateVersion = "20.03";

  nix = {
    maxJobs = 8;
    buildCores = 16;
  };
}
