pkgs: oldpkgs:
let
  rev = "d31ddcb42cd9c64438c3c452fc8814ca0e7494f3";
  sha256 = "0n82rajqirfrgsfnklz9hxgwz7myhs49pz1faanl5k77f7l3wjcp";
  tarball = builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  };
in { unstable = import tarball { config = pkgs.config; }; }
