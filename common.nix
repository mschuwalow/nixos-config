{ config, pkgs, ... }:
let
  sshDir = ./ssh;
  secrets = import ./secrets.nix;
in
{
	imports = [
		./home-manager.nix
		./users/mschuwalow.nix
	];

  i18n = {
    consoleFont = "lat9w-16";
    # consoleKeyMap = "colemak/en-latin9";
    defaultLocale = "en_US.UTF-8";
  };

  # Use the systemd-boot EFI boot loader.
  boot.cleanTmpDir = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;

	system.stateVersion = "18.09";
	time.timeZone = "Europe/Berlin";

  nixpkgs.config = {
    allowUnfree = true;

    oraclejdk.accept_license = true;

    packageOverrides = pkgs: {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;
    };
  };

  networking.networkmanager.enable = true;

  networking.firewall = {
	enable = true;
    allowedTCPPorts = [ 22 ];
	allowPing = true;
  };

  services.openssh = {
  	enable = true;
  	passwordAuthentication = false;
  	authorizedKeysFiles = [
  	 "${sshDir}/schuwalow_rsa.pub"
  	];
  };
  programs.ssh.startAgent = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    mkpasswd
    micro
    zsh
    exa
    fzf
    tmux

    jq
    cowsay
    lolcat
  ];

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.root = {
      hashedPassword = secrets.hashedRootPassword;
    };
  };


  programs.tmux = {
    enable = true;
    baseIndex = 1;
    extraTmuxConf = ''
      run-shell ${pkgs.tmuxPlugins.fpp}/share/tmux-plugins/fpp/fpp.tmux
      run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
      ${builtins.readFile ./configs/tmux.conf}
    '';
  };
}