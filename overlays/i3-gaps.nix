pkgs: oldpkgs:
let
  rev = "234d6855e3cb29c1b0c78170b5c435ba422303db";
  sha256 = "https://github.com/mschuwalow/i3-1";
  tarball = builtins.fetchurl {
    inherit sha256;
    url = "https://github.com/mschuwalow/i3-1/archive/${rev}.tar.gz";
  };
in { 
  i3-gaps = oldpkgs.i3-gaps.overrideAttrs { src = tarball; };
}
