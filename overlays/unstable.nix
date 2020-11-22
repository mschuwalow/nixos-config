self: super:
let checkout = ../checkouts/nixpkgs-unstable;
in { unstable = import checkout { config = super.config; }; }
