{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ scanmem bottles devilutionx ];
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
