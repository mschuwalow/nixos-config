{ config, ... }:

{
  imports = [
    ./audio.nix
    ./desktop
    ./development.nix
    ./jvm.nix
    ./docker.nix
    ./tmux.nix
    ./vpn.nix
  ];
}
