let
  pin = { rev, sha256, owner ? "NixOS", repo ? "nixpkgs" }: builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
  };
in
{
  unstable = pin {
    rev = "f0fec244ca380b9d3e617ee7b419c59758c8b0f1";
    sha256 = "0ga51457fb30b8j9v8is7wwf9ld9p51nizm8yhj09l23qpyh8np9";
  };
}
