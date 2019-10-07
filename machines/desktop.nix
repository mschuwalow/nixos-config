{ config, pkgs, ... }:

{
  networking.hostName = "mschuwalow-desktop";
  time.hardwareClockInLocalTime = true;

  boot.kernelParams = [
    "idle=nomwait"
  ];
  services.xserver.videoDrivers = [ "nvidia" ];

  nix = {
    maxJobs = 4;
    buildCores = 8;
  };
}