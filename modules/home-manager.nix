{ config, lib, pkgs, ... }:

let
  rev = "e27cd96494c91534797d5620698168ea9d7a49b6";
in
{
  imports = [
    (import (fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
      sha256 = "10knp7bl6ql14szkgmc1lfb649i22ab21kkq8pc0gjrdsvpgnlsj";
    }) {}).nixos
  ];
}
