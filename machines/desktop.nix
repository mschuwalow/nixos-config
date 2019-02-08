{ config, pkgs, ... }:

{
	imports = [
		../hardware-configuration.nix
		../common-configuration.nix
	];

  networking.hostName = "mschuwalow-desktop";

  services.xserver.videoDrivers = [ "nvidia" ];

  nix = {
    maxJobs = 4;
    buildCores = 8;
  };
}