{ config, pkgs, ... }:
{
  imports = [
    ./profiles/bluetooth.nix
  ];

  networking.hostName = "mschuwalow-laptop";

  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [
    "intel"
  ];

  boot.kernelParams = [];

  hardware.bluetooth.enable = true;
  services.tlp.enable = true;
    
  nix = {
    maxJobs = 2;
    buildCores = 2;
  };
}
