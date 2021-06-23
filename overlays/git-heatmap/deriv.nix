{ pkgs, system, stdenv, fetchFromGitHub, lib, nodejs-10_x }:
let
  inherit (stdenv) mkDerivation;

  bars = (import ./node {
    inherit pkgs system;
    nodejs = nodejs-10_x;
  })."bars-git://github.com/jez/bars.git";

in
mkDerivation rec {
  name = "git-heatmap";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "jez";
    repo = name;
    rev = version;
    sha256 = "ZX9BRaSbK79PCh0r4gPAivEK7zmuCcHdVQAZZQX3zr0=";
  };

  buildInputs = [ bars ];

  postBuild = ''
    substituteInPlace git-heatmap \
    --replace "bars" "${bars}/bin/bars"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 git-heatmap $out/bin/git-heatmap
  '';
}
