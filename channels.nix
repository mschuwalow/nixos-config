let
fetchChannel = { rev, sha256 }: fetchTarball {
  inherit sha256;
  url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
};
in
{
  stable = fetchChannel {
    rev = "109a28ab954a0ad129f7621d468f829981b8b96c";
    sha256 = "12wnxla7ld4cgpdndaipdh3j4zdalifk287ihxhnmrzrghjahs3q";
  };

  unstable = fetchChannel {
    rev = "1233c8d9e9bc463899ed6a8cf0232e6bf36475ee";
    sha256 = "0gs8vqw7kc2f35l8wdg7ass06s1lynf7qdx1a10lrll8vv3gl5am";
  };
}