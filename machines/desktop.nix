{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../common-configuration.nix
  ];

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