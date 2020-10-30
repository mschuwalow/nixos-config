self: super:
let
  src = super.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "b52da4e64108eb1496c037b4ca0f347624e50d51";
    sha256 = "13gn8ahjl7ykavvk4d657mlxn5zdkdzld0rk8s3x5bd7v2vfpwpy";
  };
in { unstable = import src { config = super.config; }; }
