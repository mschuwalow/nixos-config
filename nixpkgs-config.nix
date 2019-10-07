{ pkgs, ... }:
let
  pins = import ./pins.nix;
  customPkgs = import ./pkgs/default.nix { 
    inherit pkgs;
  };
  config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
    packageOverrides = pkgs: {
      unstable = import (pins.unstable) {
        inherit config;
      };
      custom = customPkgs;
      nur = customPkgs.nur;
    };
  };
in
{
  nixpkgs.config = config;
} 
