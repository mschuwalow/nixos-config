{ config, pkgs, lib, ... }:

let inherit (lib) hiPrio;
in {

  imports = [
    ./secrets

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
    (hiPrio parallel)
    most
    ncdu
    nix-index
    nix-prefetch
    nox
    peco
    powertop
    ripgrep
    sd
    tealdeer
    termdown
    tree
    unrar
    bottom
    micro
    unzip
    wget
    whois
    zip
    usbutils
    pciutils
    pmutils
    nfs-utils
    agenix
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
  };

  nix = {
    autoOptimiseStore = true;
    cachix-hook = {
      enable = true;
      cacheName = "mschuwalow-nixos-systems";
      cachePublicKey =
        "mschuwalow-nixos-systems.cachix.org-1:yE2aPTt48ovOna+s52CklrygkFXcMLIXmrTu6aB6cSU=";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixUnstable;
    useSandbox = "relaxed";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      trusted-users = "@wheel";
    };
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
    tmux = {
      enable = true;
      newSession = true;
      clock24 = true;
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

  time.timeZone = "Europe/Berlin";

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };
}
