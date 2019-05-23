{ stdenv, nodejs-10_x }:
let
bars = (import ./node { nodejs = nodejs-10_x; })."bars-jez/bars#6f5cde29afce17dbf6b28e9b33f7c8e8c28166f9";
rev = "258cb7979e364483d6910acef474377decc9fcb8";
sha256 = "1gffyw2na680apfw22df77phmwcaq01y4aqx197vyawvli2l2zv5";
src = fetchTarball {
	url = "https://github.com/jez/git-heatmap/archive/${rev}.tar.gz";
	sha256 = sha256;
};
in
stdenv.mkDerivation rec {
  version = "0.10.3-dev";
  name = "git-heatmap";
  inherit src;
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