{ config, lib, pkgs, ... }:

let
	sysPkgs = pkgs;
	# channels = import ../modules/channels.nix;
	# pkgs = channels.unstable;
	secrets = import ../secrets.nix;
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
      "networkmanager" "systemd-journal"
    ];
    createHome = true;
    home = "/home/mschuwalow";
    hashedPassword = secrets.hashedMschuwalowPassword;
  };

  home-manager = {
    users.mschuwalow = {

      programs.command-not-found.enable = true;

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
        zathura # document viewer
        bc
        ncdu # Disk space usage analyzer
        ripgrep # rg, fast grepper
        rtv # Reddit
        tdesktop # Telegram
        chromium
        alacritty
        zim # desktop wiki
        whois
        nix-prefetch-git
        binutils-unwrapped

        stow
        gawk
		    httpstat
        
        seafile-client
        keepassxc

        python3Full
        
        kubetail
        kubectl
        helm
      ]);

      #gtk = {
      #  enable = true;
      #  theme = {
      #    package = pkgs.adapta-gtk-theme;
      #    name = "Adapta-Eta";
      #  };
      #  iconTheme = {
      #    package = pkgs.paper-icon-theme;
      #    name = "Paper";
      #  };
      #};
  
      #qt = {
      #  enable = true;
      #  useGtkTheme = true;
      #};

      home.file = lib.listToAttrs (
        map (
          name: (lib.nameValuePair "${name}" ({ source = "${confDir}/${name}"; }))
        ) (recFiles confDir)
      ) // {
        # sensitive files
        ".m2/settings.xml".text = secrets.m2Settings;
        ".m2/settings-security.xml".text = secrets.m2SettingsSecurity;
      };
    };
  };
}
