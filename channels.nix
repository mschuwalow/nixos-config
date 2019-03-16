let
fetchChannel = { rev, sha256 }: fetchTarball {
  inherit sha256;
  url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
};
fetchPkgs = { rev, sha256 }: fetchTarball {
  inherit sha256;
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
};
in
{
  stable = fetchChannel {
    rev = "5d3fd3674a66c5b1ada63e2eace140519849c967";
    sha256 = "1yjn56jsczih4chjcll63a20v3nwv1jhl2rf6rk8d8cwvb10g0mk";
  };

  unstable = fetchPkgs {
    rev = "f7156588b28ea77c08a07a2d81298ebfb493330e";
    sha256 = "0k2h1vv6izrnwqx838q4833d3r45154nif4828f2hf2jvlx8ah6r";
  };
}