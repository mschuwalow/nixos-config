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
    rev = "07b42ccf2de451342982b550657636d891c4ba35";
    sha256 = "1a7ga18pwq0y4p9r787622ry8gssw1p6wsr5l7dl8pqnj1hbbzwh";
  };

  unstable = fetchPkgs {
    rev = "f7156588b28ea77c08a07a2d81298ebfb493330e";
    sha256 = "0k2h1vv6izrnwqx838q4833d3r45154nif4828f2hf2jvlx8ah6r";
  };
}