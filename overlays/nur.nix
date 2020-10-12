self: super:
let
  src = super.fetchFromGitHub {
    owner = "nix-community";
    repo = "nur";
    rev = "1f6a8c94a346f4ae51088801740640f8c5b5b966";
    sha256 = "1iyay841z50hgqakgl4v3lsb99c731ij2pdi324fpdgw8vvjjmqz";
  };
in {
  nur = import src {
    nurpkgs = super;
    pkgs = super;
  };
}
