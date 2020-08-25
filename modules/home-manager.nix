{ lib, ... }:
let
  rev = "9854342b9f088712ca3c5b67059fff5ec4f59182";
  sha256 = "1zy443ihvdaifx5ckb2akkvrqlbnym6k63rl00zhy5ik9fdyqxla";
  home-manager = fetchTarball {
    inherit sha256;
    url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
  };
in {
  _module.args.hmLib = import "${home-manager}/modules/lib" { inherit lib; };
  
  imports = [
    "${home-manager}/nixos"
  ];
}
