{ pkgs, ... }:
let
  i3-config = import ./i3.nix { inherit pkgs; };
  i3-config-file = pkgs.writeTextFile {
    name = "i3.conf";
    text = i3-config;
  };
in
{
  environment.systemPackages = with pkgs; [
    gnome3.dconf
    gnome3.gnome-disk-utility
    gnome3.gnome-system-monitor
    gnome3.nautilus

    alacritty

    custom.rocketchat
    spotify
    skypeforlinux

    seafile-client
    keepassxc

    powertop
    screenkey
    mupdf
    discord
  ];

  services = {
    compton = {
      enable = true;
      fade = true;
      shadow = true;
      shadowOpacity = "0.7";
    };

    flatpak.enable = true;
    dbus.packages = [ pkgs.gnome3.dconf ];
    gnome3.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "colemak";

      enableCtrlAltBackspace = true;

      displayManager.lightdm = {
        greeters.gtk = {
          theme.name = "Adapta-Eta";
          theme.package = pkgs.adapta-gtk-theme; 
          iconTheme.name = "Paper";
          iconTheme.package = pkgs.paper-icon-theme; 
        };
        enable = true;
      };
      desktopManager = {
        default = "none";
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        configFile = i3-config-file;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          python3
          rofi
          feh
          maim
          i3status
          i3lock
          (python3Packages.py3status.overrideAttrs (oldAttrs: {
            propagatedBuildInputs = [ python3Packages.pytz python3Packages.tzlocal python3Packages.dbus-python ];
          }))
        ];
      };
    };
  };

  programs.dconf.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    driSupport = true;
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      font-awesome_5
      
      fantasque-sans-mono
      source-code-pro
      fira-code
      roboto
      roboto-mono
      roboto-slab
    ];
    fontconfig = {
      penultimate.enable = true;
      ultimate.enable = false;
      defaultFonts = {
        monospace = [ "roboto-mono" ];
        sansSerif = [ "roboto" ];
        serif = [ "roboto-slab" ];
      };
    };
  };
}
