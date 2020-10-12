self: super:
let
  src = super.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "d31ddcb42cd9c64438c3c452fc8814ca0e7494f3";
    sha256 = "0n82rajqirfrgsfnklz9hxgwz7myhs49pz1faanl5k77f7l3wjcp";
  };
in { unstable = import src { config = super.config; }; }
