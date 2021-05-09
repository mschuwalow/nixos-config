self: super:
{ gdm = super.gdm.overrideAttrs (oldAttrs: {
  passthru = oldAttrs.passthru // { initialVT = "1"; };
}); }
