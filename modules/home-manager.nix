{ config, pkgs, lib, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  imports = [ ./home-manager/nixos ];
  vars.hmLib = import ./home-manager/modules/lib { inherit lib; };
}
