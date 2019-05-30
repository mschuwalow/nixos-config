{ config, pkgs, lib, ... }:

let
  hm = import ../../modules/home-manager.nix { inherit lib; };

  secrets = import ../../secrets;
  confDir = "/etc/nixos/users/mschuwalow/config";

  recFilesH = x: if lib.pathIsDirectory x
                  then (lib.concatMap (y: recFilesH (toString x + "/" + toString y)) (builtins.attrNames (builtins.readDir x)))
                  else [x];
  recFiles = x: if lib.pathIsDirectory x
                  then (map(y: lib.removePrefix (toString x + "/") y) (recFilesH x))
                  else [x];

  files = lib.listToAttrs (
    map (
      name: (lib.nameValuePair "${name}" ({ source = "${confDir}/${name}"; }))
    ) (recFiles confDir)
  ) // {
    # sensitive files
    ".m2/settings.xml".source = secrets.m2SettingsFile;
    ".m2/settings-security.xml".source = secrets.m2SecSettingsFile;
    ".config/sublime-text-3/Packages/User/SyncSettings.sublime-settings".source = secrets.st3SyncSettingsFile;
    ".kube/config".source = secrets.kubeconfigFile;
  };

  homeDirectory = "/home/mschuwalow";
in
{
  imports = [
    hm.nixos
  ];

  users.users.mschuwalow = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "networkmanager" "systemd-journal" "docker"
    ];
    createHome = true;
    home = homeDirectory;
    hashedPassword = secrets.hashedMschuwalowPassword;
  };

  home-manager = {
    users.mschuwalow = {

      programs.command-not-found.enable = true;
      programs.home-manager.enable = true;
      programs.direnv.enable = true;

      programs.zsh = {
        enable = true;
        initExtra = "source ${import ./zshrc.nix { inherit pkgs; }}";
        history = {
          save = 50000;
        };
        shellAliases = {
          ll = "${pkgs.exa}/bin/exa -lhg --git";
          la = "${pkgs.exa}/bin/exa -lahg --git";
          dc = "${pkgs.docker-compose}/bin/docker-compose";
          se = "sudo -E";
          nixedit = "se ${pkgs.sublime3}/bin/sublime /etc/nixos";
        };
      };

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
          diff.tool = "Sublime Merge";
          "difftool \"Sublime Merge\"".cmd = "smerge difftool \"$LOCAL\" \"$REMOTE\" -o \"$MERGED\"";
          merge.tool = "Sublime Merge";
          "mergetool \"Sublime Merge\"".cmd = "smerge mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" -o \"$MERGED\"";
        };
      };

      home.packages = with pkgs; ([
        vlc
        shutter
        bc
        ncdu
        rtv
        tdesktop
        whois
        nix-prefetch-git

        gawk
        httpstat
        
        kubetail
        kubectl
        helm
        awscli
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

      home.sessionVariables = {
        EDITOR = "${pkgs.micro}/bin/micro";
        VISUAL = "${pkgs.micro}/bin/micro";
        PAGER = "${pkgs.more}/bin/more";
        PROJECT_HOME = "$HOME_PROJECTS";
        MICRO_TRUECOLOR = "1";
        REVIEW_BASE = "master";
        ZPLUG_HOME = "$HOME/.zplug";
        TPM_HOME = "$HOME/.tmux/plugins/tpm";
        MAVEN_OPTS = "-XX:+TieredCompilation -XX:TieredStopAtLevel=1";
        SBT_OPTS ="-Xmx4G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M -Duser.timezone=GMT";
        _JAVA_OPTIONS = "-Dsun.java2d.uiScale.enabled=false -Dprism.allowhidpi=false -Dsun.java2d.uiScale=1.0 -XX:+UnlockExperimentalVMOptions";
        FZF_DEFAULT_OPTS = "--height 80% --reverse";
        FZFZ_EXTRA_DIRS = "$PROJECT_HOME";
      };

      home.activation.linkFiles = hm.lib.dag.entryAfter [ "writeBoundary" ] (
        lib.strings.concatMapStrings
          (s: ''
          mkdir --parents ''$(dirname ${s.target})
          ln -sf ${s.source} ${s.target}
          '')
          (lib.attrsets.mapAttrsToList (name: value: { source = lib.strings.escapeShellArg value.source; target = lib.strings.escapeShellArg "${homeDirectory}/${name}"; }) files)
      );

      home.file = {
        ".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
      };

    };
  };
}
