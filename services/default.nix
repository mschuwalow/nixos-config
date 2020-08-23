{ config, pkgs, ... }:

{
  imports = [
    ./fstrim.nix 
    ./ntp.nix 
    ./sshd.nix
  ];
}
