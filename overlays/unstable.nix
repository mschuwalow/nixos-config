pkgs: oldpkgs:
let
  rev = "70cfd9d25e1d4f5a40f5d0a518f0749635792667";
  sha256 = "05hrcqi41fgsxvc94c4al7jk9nbpzk1lvms1ygxn2vd7yfqgavim";
  tarball = builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  };
in
{
  unstable = import tarball { config = pkgs.config; };
}
