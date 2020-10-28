{ config, pkgs, lib, hmLib, myLib, secrets, rootDir, ... }:

let
  homeDirectory = "/home/mschuwalow";
  userSecrets = secrets.users.mschuwalow;

  files = (myLib.listFiles "${rootDir}/users/mschuwalow/files")
    // (myLib.listFiles userSecrets.files);

in {

  home-manager = {
    users.mschuwalow = {

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
          PATH = "~/bin:\${PATH}";
          EDITOR = "${pkgs.micro}/bin/micro";
          VISUAL = "${pkgs.micro}/bin/micro";
          PAGER = "${pkgs.more}/bin/more";
          ROVER_PAGER = "${pkgs.less}/bin/less";
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

      };

      programs = {
        direnv.enable = true;
        git = {
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
            my-branch = "branch --show-current";
            reset-branch =
              "!git reset $(git merge-base $REVIEW_BASE $(git my-branch))";
          };
          extraConfig = {
            core = {
              editor = "micro";
              whitespace = "trailing-space,space-before-tab";
            };
            diff.tool = "Sublime Merge";
            difftool.prompt = false;
            "difftool \"Sublime Merge\"" = {
              cmd = ''
                ${pkgs.unstable.sublime-merge}/bin/smerge difftool "$LOCAL" "$REMOTE" -o "$MERGED"'';
            };
            merge.tool = "Sublime Merge";
            "mergetool \"Sublime Merge\"" = {
              cmd = ''
                ${pkgs.unstable.sublime-merge}/bin/smerge mergetool "$BASE" "$LOCAL" "$REMOTE" -o "$MERGED"'';
              trustExitCode = true;
            };
          };
        };
        home-manager.enable = true;
        zsh = {
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
      };

      qt = {
        enable = true;
        platformTheme = "gtk";
      };

      xresources.properties = {
        "rofi.bw" = 0;
        "rofi.color-active" =
          [ "argb:2c1d1f21" "#65acff" "argb:2c1d1f21" "#4491ed" "#f9f9f9" ];
        "rofi.color-enabled" = true;

        "rofi.color-normal" =
          [ "argb:96404552" "#c4cbd4" "argb:96404552" "#4084d6" "#f9f9f9" ];
        "rofi.color-urgent" =
          [ "argb:2c1d1f21" "#cc6666" "argb:2c1d1f21" "#a54242" "#f9f9f9" ];
        "rofi.color-window" = [ "argb:f22d303b" "#7c8389" "#1d1f21" ];
        "rofi.font" = "SauceCodePro Nerd Font SemiBold 9";
        "rofi.lines" = 19;
        "rofi.location" = 7;
        "rofi.modi" = "window,run,drun,ssh";
        "rofi.opacity" = 95;
        "rofi.padding" = 5;
        "rofi.seperator-style" = "solid";
        "rofi.sidebar-mode" = true;
        "rofi.ssh-command" = "{terminal} -e {ssh-client} {host}";
        "rofi.terminal" = "${pkgs.alacritty}/bin/alacritty";
        "rofi.width" = 720;
      };
    };
  };

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

}
