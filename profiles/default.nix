{ config, ... }:

{
  imports = [
    ./audio.nix
    ./desktop
    ./games.nix
    ./development.nix
    ./jvm.nix
    ./docker.nix
    ./tmux.nix
    ./vpn.nix
    ./mounts.nix
  ];
}