pkgs: oldPkgs:
let
in {
  i3-gaps = oldPkgs.i3-gaps.overrideAttrs
    (oldAttrs: rec { patches = [ ./enable-nonprimary.patch ]; });
}
