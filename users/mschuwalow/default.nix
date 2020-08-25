{ config, pkgs, lib, secrets, rootDir, hmLib, ... }:

let
  homeDirectory = "/home/mschuwalow";
  userSecrets = secrets.users.mschuwalow;

  recFiles = x:
    if lib.pathIsDirectory x then
      (lib.concatMap (y: recFiles (toString x + "/" + toString y))
        (builtins.attrNames (builtins.readDir x)))
    else
      [ x ];

  recDir = x:
    if lib.pathIsDirectory x then
      (map (y: lib.removePrefix (toString x + "/") y) (recFiles x))
    else
      [ ];

  listFiles = dir:
    lib.listToAttrs (map (name:
      (lib.nameValuePair (toString name) ({ source = "${dir}/${name}"; })))
      (recDir dir));

  files = (listFiles "${rootDir}/users/mschuwalow/files")
    // (listFiles userSecrets.files);

in {
  users.users.mschuwalow = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "disk"
      "audio"
      "video"
      "networkmanager"
      "systemd-journal"
      "docker"
    ];
    createHome = true;
    home = homeDirectory;
    hashedPassword = userSecrets.password;
  };

  home-manager = {
    users.mschuwalow = {

      programs.command-not-found.enable = true;
      programs.home-manager.enable = true;
      programs.direnv.enable = true;

      programs.zsh = {
        enable = true;
        initExtra = "source ${import ./zshrc.nix { inherit pkgs; }}";
        history = { save = 50000; };
        shellAliases = {
          ll = "${pkgs.exa}/bin/exa -lhg --git";
          la = "${pkgs.exa}/bin/exa -lahg --git";
          dc = "${pkgs.docker-compose}/bin/docker-compose";
          se = "sudo -E";
          nixedit = "${pkgs.vscode}/bin/code /etc/nixos";
          nixrebuild =
            "sudo nixos-rebuild -I nixpkgs=/etc/nixos/nixpkgs -I nixpkgs-overlays=/etc/nixos/overlays/";
        };
      };

      programs.git = {
        package = pkgs.gitAndTools.gitFull;
        enable = true;
        userName = "Maxim Schuwalow";
        userEmail = "maxim.schuwalow@gmail.com";
        aliases = {
          files = "diff --name-only $(git merge-base HEAD $REVIEW_BASE)";
          stat = "diff --stat $(git merge-base HEAD $REVIEW_BASE)";
          heatmap = "!git-heatmap -b $REVIEW_BASE";
          review = "difftool $REVIEW_BASE --dir-diff";
          reviewone = "difftool $REVIEW_BASE --";
          sminit = "submodule update --init --recursive --progress";
          releaseNotes =
            "log --pretty=format:'- %s%n%b' --since='$(git show -s --format=%ad `git rev-list --tags --max-count=1`)'";
          sh =
            "log --graph --all --simplify-by-decoration --decorate --pretty=format:'%Cred%h%Creset - %C(yellow)%cd%Creset -%C(green)%d%Creset %s %C(bold blue)<%an>%Creset' --date=short";
          shr =
            "log --graph --all --simplify-by-decoration --decorate --pretty=format:'%Cred%h%Creset - %C(yellow)%cd%Creset -%C(green)%d%Creset %s %C(bold blue)<%an>%Creset' --date=relative";
          fh =
            "log --graph --all --pretty=format:'%Cred%h%Creset - %C(yellow)%cd%Creset -%C(green)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=short";
          fhr =
            "log --graph --all --pretty=format:'%Cred%h%Creset - %C(yellow)%cd%Creset -%C(green)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
          news = "log --word-diff=color -p HEAD@{1}..HEAD@{0}";
          st = "status --short --branch";
        };
        extraConfig = {
          core = {
            editor = "micro";
            whitespace = "trailing-space,space-before-tab";
          };
          diff.tool = "Sublime Merge";
          "difftool \"Sublime Merge\"".cmd =
            ''smerge difftool "$LOCAL" "$REMOTE" -o "$MERGED"'';
          merge.tool = "Sublime Merge";
          "mergetool \"Sublime Merge\"".cmd =
            ''smerge mergetool "$BASE" "$LOCAL" "$REMOTE" -o "$MERGED"'';
        };
      };

      home.packages = with pkgs; ([
        vlc
        shutter
        rtv

        kubetail
        kubectl
        helm
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
        gtk2.extraConfig = ''
          gtk-icon-sizes = "panel-menu=24,24:panel=20,20:gtk-button=18,18:gtk-large-toolbar=24,24"'';
      };

      qt = {
        enable = true;
        platformTheme = "gtk";
      };

      home.sessionVariables = {
        EDITOR = "${pkgs.micro}/bin/micro";
        VISUAL = "${pkgs.micro}/bin/micro";
        PAGER = "${pkgs.more}/bin/more";
        PROJECT_HOME = "$HOME/Projects";
        SAVEHIST = "500000";
        HISTSIZE = "500000";
        HISTFILE = "$HOME/.zsh_history";
        MICRO_TRUECOLOR = "1";
        REVIEW_BASE = "master";
        ZPLUG_HOME = "$HOME/.zplug";
        TPM_HOME = "$HOME/.tmux/plugins/tpm";
        MAVEN_OPTS = "-XX:+TieredCompilation -XX:TieredStopAtLevel=1";
        SBT_OPTS =
          "-J-Xmx4G -J-XX:+UseConcMarkSweepGC -J-XX:+CMSClassUnloadingEnabled -J-XX:MaxPermSize=2G -J-Xss2M -J-Duser.timezone=GMT";
        _JAVA_OPTIONS =
          "-Dsun.java2d.uiScale.enabled=false -Dprism.allowhidpi=false -Dsun.java2d.uiScale=1.0 -XX:+UnlockExperimentalVMOptions";
        FZF_DEFAULT_OPTS = "--height 80% --reverse";
        FZFZ_EXTRA_DIRS = "$PROJECT_HOME";
      };

      home.activation.linkFiles = hmLib.dag.entryAfter [ "writeBoundary" ]
        (lib.strings.concatMapStrings (s: ''
          mkdir --parents $(dirname ${s.target})
          ln -sf ${s.source} ${s.target}
        '') (lib.attrsets.mapAttrsToList (name: value: {
          source = lib.strings.escapeShellArg value.source;
          target = lib.strings.escapeShellArg "${homeDirectory}/${name}";
        }) files));

      home.file = {
        ".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
      };

    };
  };
}
