{ config, pkgs, ... }:
let
  secrets = import ./secrets;
  channels = import ./channels.nix { fetchgit = pkgs.fetchgit; };
  unstablePkgs = import (channels.unstable) {
    config = config.nixpkgs.config;
  };
  customPkgs = import ./pkgs/default.nix { pkgs = unstablePkgs; };
in
{
  imports = [
    # load default services & profiles
    ./services
    ./profiles

    # create users
    ./users/mschuwalow
  ];

  nix = {
    nixPath = [ 
      "nixpkgs=${channels.stable}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    autoOptimiseStore = true;
    useSandbox = "relaxed";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = unstablePkgs;
      custom = customPkgs;
      nur = customPkgs.nur;
    };
  };

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
    btrfs-progs
    ripgrep
    zip
    unzip
    htop
    moreutils
    tree
    nox
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
      "fs.inotify.max_user_watches"   = 1048576;   # default:  8192
      "fs.inotify.max_user_instances" =    1024;   # default:   128
      "fs.inotify.max_queued_events"  =   32768;   # default: 16384
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

    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 445 139 ];
      allowedUDPPorts = [ 137 138 ];
    };

    hosts = {
      "127.0.0.1" = [
        "www.sublimetext.com"
        "sublimetext.com"
      ];
    };
  };

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.root = {
      hashedPassword = secrets.hashedRootPassword;
    };
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

  services = {
    dbus.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  system = {
    stateVersion = "18.09";
    autoUpgrade.enable = true;
  };
}
