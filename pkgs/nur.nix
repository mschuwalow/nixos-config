{ pkgs }:
let
  rev = "3a6a6f4da737da41e27922ce2cfacf68a109ebce";
  sha = "04387gzgl8y555b3lkz9aiw9xsldfg4zmzp930m62qw8zbrvrshd";
in builtins.fetchTarball {
  # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
  url = "https://github.com/nix-community/NUR/archive/${rev}.tar.gz";
}
