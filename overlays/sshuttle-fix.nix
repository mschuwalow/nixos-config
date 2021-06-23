self: super:
let
  rev = "fa54dd346fe5e73d877f2068addf6372608c820b";
  pkgs = import
    (builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs-channels/archive/${rev}.tar.gz";
      sha256 = "1428qilgk9h9w0lka0xmjnrkllyz16kny1afz3asr0qnr63wyzdk";
    })
    {
      system = super.system;
      config = super.config;
    };
in
{ sshuttle-old = pkgs.sshuttle; }
