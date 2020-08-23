{ config, pkgs, ... }: {
  imports = [ ./profiles/bluetooth.nix ];

  networking.hostName = "mschuwalow-laptop";

  boot.kernelParams = [ ];

  hardware.bluetooth.enable = true;

  services = {
    xserver.libinput.enable = true;
    xserver.videoDrivers = [ "intel" ];
    tlp.enable = true;
  };

  system.stateVersion = "20.03";

  nix = {
    maxJobs = 2;
    buildCores = 2;
  };
}
