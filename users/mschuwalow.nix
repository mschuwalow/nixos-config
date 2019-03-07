{ pkgs, lib, ... }:

let
  sysPkgs = pkgs;
  secrets = import ../secrets;
  confDir = ./mschuwalow.config;
  recFilesH = x: if lib.pathIsDirectory x
                  then (lib.concatMap (y: recFilesH (toString x + "/" + toString y)) (builtins.attrNames (builtins.readDir x)))
                  else [x];
  recFiles = x: if lib.pathIsDirectory x
                  then (map(y: lib.removePrefix (toString x + "/") y) (recFilesH x))
                  else [x];
in
{
  users.users.mschuwalow = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "networkmanager" "systemd-journal" "docker"
    ];
    createHome = true;
    home = "/home/mschuwalow";
    hashedPassword = secrets.hashedMschuwalowPassword;
  };

  home-manager = {
    users.mschuwalow = {

      programs.command-not-found.enable = true;
      programs.home-manager.enable = true;

      programs.git = {
        package = pkgs.gitAndTools.gitFull;
        enable = true;
        userName = "Maxim Schuwalow";
        userEmail = "mschuwalow@agile-im.de";
        aliases = {
          files = "!git diff --name-only $(git merge-base HEAD $REVIEW_BASE)";
          stat = "!git diff --stat $(git merge-base HEAD $REVIEW_BASE)";
          heatmap = "!git-heatmap -b $REVIEW_BASE";
          review = "!git difftool $REVIEW_BASE --dir-diff";
          reviewone = "!git difftool $REVIEW_BASE --";
          sminit = "!git submodule update --init --recursive --progress";
        };
        extraConfig = {
          core = {
            editor = "micro";
            whitespace = "trailing-space,space-before-tab";
          };
        };
      };

      home.packages = with pkgs; ([
        vlc
        shutter # Screenshots
        bc # math
        ncdu # Disk space usage analyzer
        rtv # Reddit
        tdesktop # Telegram
        chromium
        alacritty
        zim # desktop wiki
        whois
        nix-prefetch-git

        gawk
        httpstat
        
        kubetail
        kubectl
        helm
        awscli

        jq
        cowsay
        lolcat
      ]);

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
        gtk2.extraConfig = "gtk-icon-sizes = \"panel-menu=24,24:panel=20,20:gtk-button=18,18:gtk-large-toolbar=24,24\"";
      };
  
      qt = {
        enable = true;
        useGtkTheme = true;
      };

      xsession = {
        pointerCursor = {
          package = pkgs.vanilla-dmz;
          name = "Vanilla-DMZ";
          size = 24;
        };
      };

      home.file = lib.listToAttrs (
        map (
          name: (lib.nameValuePair "${name}" ({ source = "${confDir}/${name}"; }))
        ) (recFiles confDir)
      ) // {
        # sensitive files
        ".m2/settings.xml".source = secrets.m2SettingsFile;
        ".m2/settings-security.xml".source = secrets.m2SecSettingsFile;
        ".config/sublime-text-3/Packages/User/SyncSettings.sublime-settings".source = secrets.st3SyncSettingsFile;
      };
    };
  };
}
