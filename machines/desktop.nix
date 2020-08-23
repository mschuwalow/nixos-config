{ config, pkgs, ... }:

{
  networking.hostName = "mschuwalow-desktop";
  time.hardwareClockInLocalTime = true;

  boot.kernelParams = [ "idle=nomwait" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "20.03";

  nix = {
    maxJobs = 8;
    buildCores = 16;
  };
}
