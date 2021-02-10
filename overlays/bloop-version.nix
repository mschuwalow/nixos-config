self: super:
let
  checkout = ../checkouts/nixpkgs-unstable;
  unstable = import checkout { config = super.config; };
in { bloop = unstable.bloop; }
