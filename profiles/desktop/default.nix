{ pkgs, ... }:
let i3-config = import ./i3.nix { inherit pkgs; };
in {
  environment.systemPackages = with pkgs; [
    gnome3.dconf
    gnome3.gnome-disk-utility
    gnome3.gnome-system-monitor
    gnome3.nautilus
    gnome3.eog
    gnome3.evince
    gparted
    polkit_gnome
    alacritty
    firefox
    spotify
    spotify-tui
    bitwarden
    seafile-client
    unstable.ferdi
    screenkey
    mupdf
    xclip
    transmission-gtk
    nmap-graphical
    xorg.setxkbmap
    adapta-gtk-theme
    paper-icon-theme
  ];

  xdg.portal.enable = true;

  services = {
    compton = {
      enable = true;
      fade = true;
      shadow = true;
      shadowOpacity = "0.7";
    };

    flatpak.enable = true;
    dbus.packages = with pkgs; [ gnome3.dconf gnome2.GConf ];
    gnome3.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "colemak";

      enableCtrlAltBackspace = true;

      displayManager = {
        defaultSession = "xfce+i3";
        lightdm = {
          greeters.gtk = {
            theme.name = "Adapta-Eta";
            theme.package = pkgs.adapta-gtk-theme;
            iconTheme.name = "Paper";
            iconTheme.package = pkgs.paper-icon-theme;
          };
          enable = true;
        };
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        configFile = i3-config;
        package = pkgs.i3-gaps;
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
      defaultFonts = {
        monospace = [ "roboto-mono" ];
        sansSerif = [ "roboto" ];
        serif = [ "roboto-slab" ];
      };
    };
  };
}
