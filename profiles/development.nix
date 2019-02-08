{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zeal
    vscode
    idea.idea-ultimate
    meld
    python3Full
  ];

}
