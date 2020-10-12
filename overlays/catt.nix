self: super:
let
  unstable = import (super.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "d31ddcb42cd9c64438c3c452fc8814ca0e7494f3";
    sha256 = "0n82rajqirfrgsfnklz9hxgwz7myhs49pz1faanl5k77f7l3wjcp";
  }) { config = self.config; };
in {
  catt-forked = unstable.catt.overrideAttrs (oldAttrs: rec {
    src = super.fetchFromGitHub {
      owner = "mschuwalow";
      repo = "catt";
      rev = "700c3dd9d9e4f773b78f17028157354138dc742e";
      sha256 = "13wpxgm55b4ilgbzlnn1ckc92mpi52n7ws5j43wf88wpbwjarbrl";
    };
  });
}
