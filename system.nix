{ pkgs, secrets, ... }:
let pins = import ./pins.nix;
in {
  imports = [
    # load system specific configuration
    ./hardware-configuration.nix
    ./machine-configuration.nix

    # load modules
    ./modules/home-manager.nix

    # load default services & profiles
    ./services
    ./profiles

    # create users
    ./users/mschuwalow
  ];

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
      (import ./overlays/pythonPackages.nix)
      (import ./overlays/git-heatmap)
      (import ./overlays/rocketchat)
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    mkpasswd
    unstable.micro
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
    unstable.ytop
    powertop
    moreutils
    tree
    bc
    whois
    ncdu
    nix-prefetch-git
    httpstat
    mawk
    fd
    nox
    most
    ncdu
    parallel
    peco
    sd
    termdown
    tree
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
    users.root = { hashedPassword = secrets.rootPassword; };
  };

  console = {
    keyMap = "colemak/colemak";
    font = "lat9w-16";
  };

  i18n = { defaultLocale = "en_US.UTF-8"; };

  programs = {
    ssh.startAgent = true;
    zsh = {
      enable = true;
      # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };
  };

  services = { dbus.enable = true; };

  time.timeZone = "Europe/Berlin";

  system = { autoUpgrade.enable = true; };
}
