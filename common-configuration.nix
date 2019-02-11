{ config, pkgs, ... }:
let
  secrets = import ./secrets.nix;
in
{
  imports = [
    # load modules
    ./modules/home-manager.nix

    # load default services & profiles
    ./services
    ./profiles

    # create users
    ./users/mschuwalow.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
    git
    mkpasswd
    micro
    exa
    fzf
    tmux
    direnv
    gptfdisk
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
      allowedTCPPorts = [ 22 ];
      allowPing = true;
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
    tmux = {
        enable = true;
        baseIndex = 1;
        extraTmuxConf = ''
          run-shell ${pkgs.tmuxPlugins.fpp}/share/tmux-plugins/fpp/fpp.tmux
          run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
          ${builtins.readFile ./configs/tmux.conf}
        '';
      };
  };

  nix = {
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
    packageOverrides = pkgs:
      import ./pkgs/default.nix { inherit pkgs;  };
  };

  time.timeZone = "Europe/Berlin";

  system = {
    stateVersion = "18.09";
	autoUpgrade.enable = true;
  };
}
