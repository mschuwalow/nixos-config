{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgs-steam.steam
    pkgs-steam.steam-run
  ];

}
