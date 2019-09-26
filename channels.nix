{ fetchgit }:
let
fetchChannel = { rev, sha256 }: fetchgit {
  inherit rev;
  inherit sha256;
  url = "https://github.com/NixOS/nixpkgs-channels";
};
fetchPkgs = { rev, sha256, owner ? "NixOS" }: fetchgit {
  inherit rev;
  inherit sha256;
  url = "https://github.com/${owner}/nixpkgs";
};
in
{
  stable = fetchChannel {
    rev = "f0fec244ca380b9d3e617ee7b419c59758c8b0f1";
    sha256 = "0ga51457fb30b8j9v8is7wwf9ld9p51nizm8yhj09l23qpyh8np9";
  };

  unstable = fetchPkgs {
    rev = "f0fec244ca380b9d3e617ee7b419c59758c8b0f1";
    sha256 = "0ga51457fb30b8j9v8is7wwf9ld9p51nizm8yhj09l23qpyh8np9";
  };

  sublime = fetchPkgs {
    rev = "4aeafc6b63fbf9b0207ce51a3bbf0bc81c807115";
    sha256 = "0va50i6fr75qlkcnrys51fv5z4z3ybjv1kdpi6r8idxsx77vhc0h";
    owner = "zookatron";   
  };
}
