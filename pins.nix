let
  fetchChannel = { rev, sha256 }: builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
  };
  fetchPkgs = { rev, sha256, owner ? "NixOS" }: builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/${owner}/nixpkgs/archive/${rev}.tar.gz";
  };
in
{
  unstable = fetchChannel {
    rev = "f0fec244ca380b9d3e617ee7b419c59758c8b0f1";
    sha256 = "0ga51457fb30b8j9v8is7wwf9ld9p51nizm8yhj09l23qpyh8np9";
  };
}
