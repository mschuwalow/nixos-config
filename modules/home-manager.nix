{ config, pkgs, lib, ... }:
let checkout = ../checkouts/home-manager;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  imports = [ "${checkout}/nixos" ];
  vars.hmLib = import "${checkout}/modules/lib" { inherit lib; };
}
