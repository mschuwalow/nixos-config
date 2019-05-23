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
    rev = "971b731fc18c86569211a460ef62e1d8001799e9";
    sha256 = "1b8xjrrwb8fz92bcrqvfvfg7gwn40ss12by2ka4yclcxk5yylmw0";
  };

  unstable = fetchPkgs {
    rev = "2ed6903da5121a32a9acbb2afcc4e5524c06931b";
    sha256 = "0q19k4aps4dlnv47vrmsazhk9wmnps8rz3clzvbfy9lrzn9v1qma";
  };

  sublime = fetchPkgs {
    rev = "4aeafc6b63fbf9b0207ce51a3bbf0bc81c807115";
    sha256 = "0va50i6fr75qlkcnrys51fv5z4z3ybjv1kdpi6r8idxsx77vhc0h";
    owner = "zookatron";   
  };
}
