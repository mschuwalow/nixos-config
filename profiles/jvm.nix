{ config, lib, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;

    oraclejdk.accept_license = true;

    packageOverrides = pkgs: {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;
    };
  };

  # install development packages
  environment.systemPackages = with pkgs; [
    maven
    jre
    jdk
  ];

}
