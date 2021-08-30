{ config, pkgs, lib, ... }:

let
  inherit (lib) hiPrio;
in
{

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
    packages = with pkgs; [ terminus_font ];
  };

  documentation.man.generateCaches = true;

  environment.systemPackages = with pkgs; [
    (hiPrio parallel)
    agenix
    bat
    bc
    bottom
    broot
    cheat
    choose
    curlie
    duf
    dust
    exa
    fd
    fzf
    gawk
    git
    glances
    gnupg
    gping
    gptfdisk
    htop
    httpie
    hyperfine
    killall
    lsof
    micro
    mkpasswd
    moreutils
    most
    ncdu
    nfs-utils
    nix-index
    nix-prefetch
    nox
    pciutils
    peco
    pmutils
    powertop
    procs
    ripgrep
    sd
    tealdeer
    termdown
    tree
    unrar
    unzip
    usbutils
    vim
    wget
    whois
    xe
    zip
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
  };

  imports = [
    ./secrets
    ./profiles
    ./users
  ];

  nix = {
    autoOptimiseStore = true;
    cachixIntegration = {
      enable = true;
      cacheName = "mschuwalow-nixos-systems";
      cachePublicKey = "mschuwalow-nixos-systems.cachix.org-1:yE2aPTt48ovOna+s52CklrygkFXcMLIXmrTu6aB6cSU=";
      cachixConfigFilePath = config.age.secrets.cachix.path;
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
      input-fonts.acceptLicense = true;
      trusted-users = "@wheel";
    };
  };

  programs = {
    command-not-found.enable = false;
    zsh = {
      enable = true;
      enableBashCompletion = true;
      histSize = 50000;
      interactiveShellInit = ''
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';
      setOptions = [
        "HIST_FCNTL_LOCK"
        "HIST_IGNORE_ALL_DUPS"
        "HIST_IGNORE_SPACE"
        "HIST_REDUCE_BLANKS"
        "HIST_VERIFY"
        "SHARE_HISTORY"
      ];
    };
  };

  security = {
    polkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  services.fwupd.enable = true;

  # Causes very long startup.
  # https://www.freedesktop.org/software/systemd/man/systemd-udev-settle.service.html
  systemd.services.systemd-udev-settle.enable = false;

  time.timeZone = "Europe/Berlin";

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };
}
