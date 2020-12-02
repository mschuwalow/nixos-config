{ config, lib, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.openjdk8;
  };

  environment.systemPackages = with pkgs; [
    coursier
    idea.idea-community
    jd-gui
    visualvm
    sbt-extras
  ];

}
