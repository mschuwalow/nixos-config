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
    ./modules/bloop-system.nix

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
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default:  8192
      "fs.inotify.max_user_instances" = 1024; # default:   128
      "fs.inotify.max_queued_events" = 32768; # default: 16384
    };
  };

  console = {
    earlySetup = true;
    font = "ter-i16b";
    keyMap = "colemak/colemak";
    packages = with pkgs; [ terminus_font ];
  };

  documentation.man.generateCaches = true;

  environment.systemPackages = with pkgs; [
    vim
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
    nix-prefetch
    nnn
    nox
    peco
    powertop
    ripgrep
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
    pmutils
    nfs-utils
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  nix = {
    autoOptimiseStore = true;
    binaryCaches = [ "https://cache.nixos.org/" "https://r-ryantm.cachix.org" ];
    binaryCachePublicKeys =
      [ "r-ryantm.cachix.org-1:gkUbLkouDAyvBdpBX0JOdIiD2/DP1ldF3Z3Y6Gqcc4c=" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nixPath = [
      "nixpkgs=/etc/nixos/checkouts/nixpkgs"
      "nixpkgs-overlays=/etc/nixos/overlays-compat/"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    package = pkgs.nixFlakes;
    useSandbox = "relaxed";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      trusted-users = "@wheel";
    };
    overlays = [
      (import ./overlays/master.nix)
      (import ./overlays/unstable.nix)
      (import ./overlays/nur.nix)
      (import ./overlays/python-packages.nix)
      (import ./overlays/git-heatmap)
      (import ./overlays/vscode-extensions)
      (import ./overlays/joplin.nix)
      (import ./overlays/ibus-rime)
      (import ./overlays/cups-kyocera-ecosys)
      (import ./overlays/sshuttle-fix.nix)
    ];
  };

  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = true;
      setOptions = [
        "HIST_IGNORE_ALL_DUPS"
        "HIST_IGNORE_SPACE"
        "SHARE_HISTORY"
        "HIST_VERIFY"
        "HIST_FCNTL_LOCK"
        "HIST_REDUCE_BLANKS"
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

  time.timeZone = "Europe/Berlin";

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };
}
