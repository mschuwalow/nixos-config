{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kvm
    qemu
    vagrant
    virtmanager
  ];

  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
  };
}
