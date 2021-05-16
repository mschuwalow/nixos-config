self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    gtktitlebar = super.callPackage ./deriv.nix { };
  };
}
