self: super: {
  i3-gaps = super.i3-gaps.overrideAttrs
    (oldAttrs: rec { patches = [ ./enable-nonprimary.patch ]; });
}
