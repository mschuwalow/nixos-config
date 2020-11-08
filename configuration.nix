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
    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        memtest86.enable = true;
        useOSProber = true;
        version = 2;
      };
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default:  8192
      "fs.inotify.max_user_instances" = 1024; # default:   128
      "fs.inotify.max_queued_events" = 32768; # default: 16384
    };
  };

  console = {
    keyMap = "colemak/colemak";
    font = "lat9w-16";
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
    httpstat
    killall
    mawk
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
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ m17n ];
    };
  };

  nix = {
    nixPath = [
      "nixpkgs=${<nixpkgs>}"
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
    ];
  };

  programs = {
    command-not-found.enable = true;
    ssh.startAgent = true;
    zsh = { enable = true; };
  };

  security = {
    polkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  time.timeZone = "Europe/Berlin";

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };

  vars.rootDir = "/etc/nixos";
}
