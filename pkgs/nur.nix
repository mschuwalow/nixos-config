{ pkgs }:
let
  rev = "2605eeb589c9c4ccbc2eb8a76f3e7f15987d0f49";
  sha = "1pa89ipnz6cq5rp99wprx9aswsvi6nxrdzv4aywjjj1qqvj0gdkp";
  tar = builtins.fetchTarball {
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    url = "https://github.com/nix-community/NUR/archive/${rev}.tar.gz";
    sha256 = sha;
  };
in
import tar { inherit pkgs; }
