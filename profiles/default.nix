{ config, ... }:

{
  imports = [
    ./audio.nix
    ./desktop.nix
    ./development.nix
    ./docker.nix
    ./jvm.nix
    ./networking.nix
    ./ntp.nix
    ./printing.nix
    ./ssd.nix
    ./sshd.nix
    ./tmux.nix
  ];
}
