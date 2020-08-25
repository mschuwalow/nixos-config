{ ... }:

{
  _module.args.rootDir = "/etx/nixos";
  imports = [ ./secrets ./system.nix ];
}
