{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker_compose
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.lxc.enable = true;
  virtualisation.lxc.usernetConfig = ''
    bfo veth lxcbr0 10
  '';

  virtualisation.docker = {
    enable = true;
  	enableOnBoot = true;
  };
}
