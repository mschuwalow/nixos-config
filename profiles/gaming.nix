{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ scanmem ];
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
