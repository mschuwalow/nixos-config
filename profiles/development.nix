{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zeal
    vscode
    sublime3
    idea.idea-ultimate
    meld
    python3Full
  ];
}
