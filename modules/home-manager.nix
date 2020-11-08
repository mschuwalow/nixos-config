{ config, pkgs, lib, ... }:
let
  rev = "a98ec6ec158686387d66654ea96153ec06be33d7";
  sha256 = "05yvpywhpnnsr55asp6m1chrfd6yf0njy49j3wc9d6qm3dipgwmc";
  home-manager = fetchTarball {
    inherit sha256;
    url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
  };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  vars = {
    home-manager-script = { username, homeDirectory ? "/home/${username}"
      , config-path ? "${homeDirectory}/.config/nixpkgs/home.nix"
      , files-path ? "${homeDirectory}/.config/nixpkgs/home-files" }:
      assert builtins.typeOf username == "string";
      let
        homeDirectory = "/home/${username}";
        home-manager-bootstrap = pkgs.writeTextFile {
          name = "home-manager-bootstrap.nix";
          text = ''
            { config, lib, pkgs, ... }:
            let
              sysconfig = (import <nixpkgs/nixos> { system = config.nixpkgs.system; }).config;
              hmLib = sysconfig.vars.hmLib;
              myLib = sysconfig.vars.myLib;
              files = myLib.listFiles "${files-path}";
            in
            {
              home.activation.linkFiles = hmLib.dag.entryAfter [ "writeBoundary" ]
                (lib.strings.concatMapStrings (s: '''
                  mkdir --parents $(dirname ''${s.target})
                  ln -sf ''${s.source} ''${s.target}
                ''') (lib.attrsets.mapAttrsToList (name: value: {
                  source = lib.strings.escapeShellArg value.source;
                  target = lib.strings.escapeShellArg "${homeDirectory}/''${name}";
                }) files));
              home.username = "${username}";
              home.homeDirectory = "${homeDirectory}";
              imports = [ ${config-path} ];
            }
          '';
        };
      in pkgs.writeShellScriptBin "home-manager" ''
        exec ${pkgs.home-manager}/bin/home-manager -f ${home-manager-bootstrap} $@
      '';
    hmLib = import "${home-manager}/modules/lib" { inherit lib; };
  };

  imports = [ "${home-manager}/nixos" ];
}
