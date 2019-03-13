let
fetchChannel = { rev, sha256 }: fetchTarball {
  inherit sha256;
  url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
};
in
{
  stable = fetchChannel {
    rev = "5d3fd3674a66c5b1ada63e2eace140519849c967";
    sha256 = "1yjn56jsczih4chjcll63a20v3nwv1jhl2rf6rk8d8cwvb10g0mk";
  };

  unstable = fetchChannel {
    rev = "1233c8d9e9bc463899ed6a8cf0232e6bf36475ee";
    sha256 = "0gs8vqw7kc2f35l8wdg7ass06s1lynf7qdx1a10lrll8vv3gl5am";
  };
}