{ config, pkgs, ... }:

{
	imports = [
		../hardware-configuration.nix
		../common-configuration.nix
	];

  networking.hostName = "mschuwalow-laptop";

  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  hardware.bumblebee.enable = false;

  nix = {
    maxJobs = 4;
    buildCores = 8;
  };
}
