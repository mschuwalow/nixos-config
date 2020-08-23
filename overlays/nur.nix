pkgs: oldPkgs:
let
  rev = "1f6a8c94a346f4ae51088801740640f8c5b5b966";
  sha256 = "1iyay841z50hgqakgl4v3lsb99c731ij2pdi324fpdgw8vvjjmqz";
  tarball = builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/nix-community/nur/archive/${rev}.tar.gz";
  };
in
{
  nur = import tarball { nurpkgs = pkgs; pkgs = pkgs; };
}
