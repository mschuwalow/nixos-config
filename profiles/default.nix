{ config, ... }:

{
  imports = [
    ./audio.nix
    ./desktop
    ./development.nix
    ./docker.nix
    ./jvm.nix
    ./networking.nix
    ./ntp.nix
    ./printing.nix
    ./sshd.nix
    ./tmux.nix
    ./vpn.nix
  ];
}
