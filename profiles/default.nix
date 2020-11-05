{ config, ... }:

{
  imports = [
    ./audio.nix
    ./desktop
    ./development.nix
    ./docker.nix
    ./jvm.nix
    ./networking.nix
    ./printing.nix
    ./tmux.nix
    ./vpn.nix
  ];
}
