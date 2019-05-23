{ pkgs }:
let
  rev = "82bd4999de0215d4de8e5b845d338f8114c590c5";
  sha = "094wqfl29dfjngbkmsdkgjzqk0z33r3cj9v2bl4gfzjzgrfi3my3";
in
(import (builtins.fetchTarball { 
  sha256 = sha;
  url = "https://github.com/nmattia/niv/archive/${rev}.tar.gz";
}) {}).niv