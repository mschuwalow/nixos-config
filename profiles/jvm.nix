{ config, lib, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;

    oraclejdk.accept_license = true;
  };

  programs.java.enable = true;

  # install development packages
  environment.systemPackages = with pkgs; [
    coursier
    idea.idea-community
    jdk8
    jd-gui
    maven
    sbt
  ];

}
