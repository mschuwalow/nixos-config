{ pkgs, ... }:
let
  pins = import ./pin.nix;
  externalPkgs = import ./pkgs/default.nix { inherit pkgs; };
  secrets = import ./secrets;
  config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
    packageOverrides = pkgs: {
      unstable = import (pins.unstable) { inherit config; };
      external = externalPkgs;
      nur = pkgs.nur;
    };
  };
in {
  imports = [
    # load system specific configuration
    ./hardware-configuration.nix
    ./machine-configuration.nix

    # load default services & profiles
    ./services
    ./profiles

    # create users
    ./users/mschuwalow
  ];

  nix = {
    nixPath = [ "nixpkgs=${<nixpkgs>}" "nixos-config=/etc/nixos/configuration.nix" ];
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

  nixpkgs.config = config;

  environment.systemPackages = with pkgs; [
    wget
    git
    mkpasswd
    micro
    exa
    fzf
    nnn
    tmux
    gnupg
    gptfdisk
    ripgrep
    zip
    unzip
    htop
    powertop
    # moreutils
    tree
    bc
    whois
    ncdu
    nix-prefetch-git
    # httpstat
    gawk
    # nox
  ];

  boot = {
    cleanTmpDir = true;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default:  8192
      "fs.inotify.max_user_instances" = 1024; # default:   128
      "fs.inotify.max_queued_events" = 32768; # default: 16384
    };
  };

  security = {
    polkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  networking = {
    networkmanager.enable = true;

    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 445 139 ];
      allowedUDPPorts = [ 137 138 ];
    };

    hosts = { "127.0.0.1" = [ "www.sublimetext.com" "sublimetext.com" ]; };
  };

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.root = { hashedPassword = secrets.hashedPasswords.root; };
  };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "colemak/colemak";
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
    ssh.startAgent = true;
    zsh.enable = true;
  };

  services = { dbus.enable = true; };

  time.timeZone = "Europe/Berlin";

  system = {
    autoUpgrade.enable = true;
  };
}
