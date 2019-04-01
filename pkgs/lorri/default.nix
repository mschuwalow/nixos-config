{ pkgs }:
let
  rev = "e943fa403234f1a5e403b6fdc112e79abc1e29ba";
  sha = "1ar7clza117qdzldld9qzg4q0wr3g20zxrnd1s51cg6gxwlpg7fa";
  
  lorri-src = fetchTarball {
    url = "https://github.com/target/lorri/archive/${rev}.tar.gz";
    sha256 = sha;
  };
  self = (import (lorri-src) { pkgs = pkgs; src = lorri-src; });
in
self