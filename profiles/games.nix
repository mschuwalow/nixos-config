{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.steam
    unstable.steam-run
  ];

}
