self: super:
let
  src = super.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "9ed8e03a09a127e4dfdbd00524ede239b94cac78";
    sha256 = "0n0n83sydkzg4c1vrmz3ma25bka4n583d7ji40dvfkydxckg4qx7";
  };
in { unstable = import src { config = super.config; }; }
