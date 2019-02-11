{ config, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./desktop.nix
    ./development.nix
    ./docker.nix
    ./tmux.nix
    ./vpn.nix
  ];
}