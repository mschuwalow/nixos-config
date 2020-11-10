{ config, pkgs, lib, ... }:
let
  rev = "4cc1b77c3fc4f4b3bc61921dda72663eea962fa3";
  sha256 = "02y6bjakcbfc0wvf9b5qky792y9abyf1kgnk8r30f1advn3x69nc";
  home-manager = fetchTarball {
    inherit sha256;
    url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
  };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  imports = [ "${home-manager}/nixos" ];
  vars.hmLib = import "${home-manager}/modules/lib" { inherit lib; };
}
