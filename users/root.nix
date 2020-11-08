{ config, pkgs, lib, secrets, ... }:

let
  hmLib = config.vars.hmLib;
  myLib = config.vars.myLib;
  homeDirectory = "/root";
  userSecrets = config.vars.secrets.users.root;
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

      home.sessionVariables = {
        EDITOR = "${pkgs.micro}/bin/micro";
        VISUAL = "${pkgs.micro}/bin/micro";
        PAGER = "${pkgs.more}/bin/more";
      };

      programs = {
        git = {
          package = pkgs.gitAndTools.gitFull;
          enable = true;
          extraConfig = { pull = { ff = "only"; }; };
          userName = "Maxim Schuwalow";
          userEmail = "maxim.schuwalow@gmail.com";
        };
        ssh = {
          enable = true;
          matchBlocks = {
            "github.com" = {
              hostname = "github.com";
              user = "git";
              identityFile = toString userSecrets.ssh.gitIdentityFile;
            };
          };
        };
      };

      qt = {
        enable = true;
        platformTheme = "gtk";
      };
    };
  };

  users.users.root = { hashedPassword = userSecrets.password; };
}
