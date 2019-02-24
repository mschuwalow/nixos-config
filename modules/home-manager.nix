{ config, lib, pkgs, ... }:

let
  rev = "e27cd96494c91534797d5620698168ea9d7a49b6";
in
{
  imports = [
    (import (fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
      sha256 = "0y4jj7nqfqa68shqx5cmzkmj2i65mbw9rmqq1i4r95sgrhc189iw";
    }) {}).nixos
  ];
}
