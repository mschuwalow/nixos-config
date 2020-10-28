{ lib, hmLib, ... }:
let

  listFiles = let
    goFiles = x:
      if lib.pathIsDirectory x then
        (lib.concatMap (y: goFiles (toString x + "/" + toString y))
          (builtins.attrNames (builtins.readDir x)))
      else
        [ x ];

    goDir = x:
      if lib.pathIsDirectory x then
        (map (y: lib.removePrefix (toString x + "/") y) (goFiles x))
      else
        [ ];
  in dir:
  lib.listToAttrs (map
    (name: (lib.nameValuePair (toString name) ({ source = "${dir}/${name}"; })))
    (goDir dir));
in { _module.args.myLib = { inherit listFiles; }; }
