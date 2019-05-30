{ config, lib, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;

    oraclejdk.accept_license = true;
  };

  # install development packages
  environment.systemPackages = with pkgs; [
    maven
    sbt
    jdk11
    jd-gui
  ];

}
