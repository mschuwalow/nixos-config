{ lib, ... }:
let
  rev = "465d08d99f5b72b38cecb7ca1865b7255de3ee86";
  sha = "1dkvz0sx8kjvk1lap50d5vfgm2wprh1cmhcrx3bn28r3skpj4rbj";
  hm = fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
    sha256 = sha;
  };
in {
  nixos = "${hm}/nixos";
  lib = import "${hm}/modules/lib" { inherit lib; };
}
