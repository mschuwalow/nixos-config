{ pkgs }:
let
  rev = "82bd4999de0215d4de8e5b845d338f8114c590c5";
in
(import (builtins.fetchTarball { 
  url = "https://github.com/nmattia/niv/archive/${rev}.tar.gz" ;
  sha256 = "11gys7rrj1jspibbi5gvdb9liq8n18mrdfvk4r1mmi20zana27ar";
}) {}).niv