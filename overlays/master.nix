self: super:
let checkout = ../checkouts/nixpkgs-master;
in { master = import checkout { config = super.config; }; }
