self: super:
let
  src = super.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "144ec0c5143e7e71a5a4ec24272b058e2ddfcff6";
    sha256 = "1dpzyxfphqcslqlq8wz6l9lkrgm888a7wyv6y2hifyvxg8sd7ml5";
  };
in { unstable = import src { config = super.config; }; }
