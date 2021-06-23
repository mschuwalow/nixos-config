{ ... }:
let
  rev = "a54bfc74c5e7ae056f61abdb970c6cd6e8fb5e53";
  sha256 = "0rvgp2k5fh1drmm8908ghzaz295b1q1ccw172850phn3chkw5kpx";
  tarball = builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/msteen/nixos-vsliveshare/archive/${rev}.tar.gz";
  };
in
{ imports = [ tarball ]; }
