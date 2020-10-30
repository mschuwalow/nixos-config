{ lib, ... }:
let
  rev = "a98ec6ec158686387d66654ea96153ec06be33d7";
  sha256 = "05yvpywhpnnsr55asp6m1chrfd6yf0njy49j3wc9d6qm3dipgwmc";
  home-manager = fetchTarball {
    inherit sha256;
    url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
  };
in {
  _module.args.hmLib = import "${home-manager}/modules/lib" { inherit lib; };

  imports = [ "${home-manager}/nixos" ];
}
