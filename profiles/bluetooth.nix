{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blueman
    obexftp
    obexfs
    bluedevil
  ];
}
