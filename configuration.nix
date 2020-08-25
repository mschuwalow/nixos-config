{ ... }:

{
  _module.args.rootDir = "/etc/nixos";
  imports = [ ./secrets ./system.nix ];
}
