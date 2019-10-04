{ pkgs }:
let
  channels = import ./channels.nix { fetchgit = pkgs.fetchgit; };
  config = {
    nixpkgs = channels.stable;
    allowUnfree = true;
    oraclejdk.accept_license = true;
    packageOverrides = pkgs: rec {
      unstable = import (channels.unstable) {
        inherit config;
      };
      custom = import ./pkgs/default.nix { 
        inherit pkgs;
      };
      nur = custom.nur;
    };    
  };
in
config
