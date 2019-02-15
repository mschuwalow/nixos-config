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
    rev = "109a28ab954a0ad129f7621d468f829981b8b96c";
    sha256 = "12wnxla7ld4cgpdndaipdh3j4zdalifk287ihxhnmrzrghjahs3q";
  };
}