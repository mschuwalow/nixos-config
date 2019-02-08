{ config, pkgs, ... }:

{
	imports = [
		../hardware-configuration.nix
		../common.nix
		../desktop.nix
	];

  networking.hostName = "mschuwalow-desktop";

  services.xserver.videoDrivers = [ "nvidia" ];

	virtualisation.docker = {
		enable = true;
		enableOnBoot = true;
	};

  nix = {
    maxJobs = 4;
    buildCores = 8;
    useSandbox = "relaxed";
  };
}