self: super:
let
  checkout = super.fetchFromGitHub {
    owner = "asbachb";
    repo = "nixpkgs";
    rev = "c3a6d66834dc75a8f15e88eca6f7838fd5be215b";
    sha256 = "r4FgKNprn9nnFCqIXJ0JNUzK0OvjOfxBnwLyoFnJp4g=";
  };
  pkgs = import checkout { system = super.system; config = super.config; };
in
{ bottles = pkgs.bottles; }
