{ config, ... }:

{
  imports = [
    ./audio.nix
    ./desktop
    ./games.nix
    ./development.nix
    ./docker.nix
    ./tmux.nix
    ./vpn.nix
  ];
}