{ config, pkgs, ... }:
let secrets = config.vars.secrets;
in {
  imports = [
    ./secrets

    # load modules
    ./modules/variables.nix
    ./modules/home-manager.nix
    ./modules/xcursor.nix
    ./modules/vsliveshare.nix
    ./modules/my-lib.nix
    ./modules/autoupgrade.nix

    # load system specific configuration
    ./hardware-configuration.nix
    ./machine-configuration.nix

    # load default services & profiles
    ./profiles

    # create users
    ./users/root.nix
    ./users/mschuwalow.nix
    ./users/pzhang.nix
  ];

  boot = {
    cleanTmpDir = true;
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default:  8192
      "fs.inotify.max_user_instances" = 1024; # default:   128
      "fs.inotify.max_queued_events" = 32768; # default: 16384
    };
  };

  console = {
    keyMap = "colemak/colemak";
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  };

  documentation.man.generateCaches = true;

  environment.systemPackages = with pkgs; [
    bc
    exa
    fd
    fzf
    git
    gnupg
    gptfdisk
    htop
    killall
    gawk
    mkpasswd
    moreutils
    most
    ncdu
    nix-index
    nix-prefetch-git
    nnn
    nox
    peco
    powertop
    ripgrep
    rover
    sd
    tealdeer
    termdown
    tmux
    tree
    unrar
    unstable.bottom
    unstable.micro
    unzip
    wget
    whois
    zip
    usbutils
    pciutils
  ];

  i18n = { defaultLocale = "en_US.UTF-8"; };

  nix = {
    nixPath = [
      "nixpkgs=/etc/nixos/checkouts/nixpkgs"
      "nixpkgs-overlays=/etc/nixos/overlays-compat/"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    binaryCaches = [ "https://cache.nixos.org/" "https://r-ryantm.cachix.org" ];
    binaryCachePublicKeys =
      [ "r-ryantm.cachix.org-1:gkUbLkouDAyvBdpBX0JOdIiD2/DP1ldF3Z3Y6Gqcc4c=" ];
    autoOptimiseStore = true;
    useSandbox = "relaxed";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      oraclejdk.accept_license = true;
    };
    overlays = [
      (import ./overlays/unstable.nix)
      (import ./overlays/nur.nix)
      (import ./overlays/custom-envs.nix)
      (import ./overlays/python-packages.nix)
      (import ./overlays/git-heatmap)
      (import ./overlays/rocketchat)
      (import ./overlays/i3-gaps)
      (import ./overlays/rover.nix)
      (import ./overlays/catt.nix)
      (import ./overlays/vscode-extensions)
      (import ./overlays/joplin.nix)
      (import ./overlays/ibus-rime)
    ];
  };

  programs = {
    ssh.startAgent = true;
    zsh = {
      enable = true;
      enableBashCompletion = true;
      promptInit = ''
        eval $(${pkgs.starship}/bin/starship init zsh)
      '';
      setOptions = [
        "HIST_IGNORE_ALL_DUPS"
        "HIST_IGNORE_SPACE"
        "SHARE_HISTORY"
        "HIST_FCNTL_LOCK"
      ];
    };
  };

  services.fwupd.enable = true;

  security = {
    polkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  system.autoUpgradeCheckout = {
    enable = true;
    sshKey = secrets.git.sshKey;
  };

  systemd.services = {
    systemd-udev-settle.enable = false;
    NetworkManager-wait-online.enable = false;
  };

  time.timeZone = "Europe/Berlin";

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };
}
