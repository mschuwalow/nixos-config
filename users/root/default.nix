{ config, pkgs, lib, hmLib, myLib, secrets, ... }:

let
  homeDirectory = "/root";
  userSecrets = secrets.users.root;

  files = myLib.listFiles userSecrets.files;

in {
  home-manager = {
    users.root = {
      gtk = {
        enable = true;
        theme = {
          package = pkgs.adapta-gtk-theme;
          name = "Adapta-Eta";
        };
        iconTheme = {
          package = pkgs.paper-icon-theme;
          name = "Paper";
        };
      };

      home = {
        activation.linkFiles = hmLib.dag.entryAfter [ "writeBoundary" ]
          (lib.strings.concatMapStrings (s: ''
            mkdir --parents $(dirname ${s.target})
            ln -sf ${s.source} ${s.target}
          '') (lib.attrsets.mapAttrsToList (name: value: {
            source = lib.strings.escapeShellArg value.source;
            target = lib.strings.escapeShellArg "${homeDirectory}/${name}";
          }) files));

        sessionVariables = {
          EDITOR = "${pkgs.micro}/bin/micro";
          VISUAL = "${pkgs.micro}/bin/micro";
          PAGER = "${pkgs.more}/bin/more";
        };
      };

      programs.git = {
        package = pkgs.gitAndTools.gitFull;
        enable = true;
        extraConfig = {
          pull = { ff = "only"; };
        };
        userName = "Maxim Schuwalow";
        userEmail = "maxim.schuwalow@gmail.com";
      };

      qt = {
        enable = true;
        platformTheme = "gtk";
      };
    };
  };

  users.users.root = { hashedPassword = userSecrets.password; };
}
