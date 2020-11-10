{ config, lib, pkgs, ... }:
let
  hmLib = config.vars.hmLib;
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
in {
  vars.myLib = {
    inherit listFiles;
    outOfStore = path:
      let
        pathStr = toString path;
        name = hmLib.strings.storeFileName (baseNameOf pathStr);
      in pkgs.runCommandLocal name { }
      "ln -s ${lib.escapeShellArg pathStr} $out";
  };
}
