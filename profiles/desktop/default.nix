{ pkgs, ... }:
let i3-config = import ./i3.nix { inherit pkgs; };
in {
  environment.systemPackages = with pkgs; [
    gnome3.gnome-disk-utility
    gnome3.gnome-system-monitor
    gnome3.gnome-font-viewer
    gnome3.nautilus
    gnome3.eog
    arandr
    gparted
    polkit_gnome
    alacritty
    google-chrome
    unstable.spotify
    unstable.spotify-tui
    bitwarden
    seafile-client
    unstable.ferdi
    screenkey
    mupdf
    okular
    usbutils
    xclip
    transmission-gtk
    nmap-graphical
    unstable.vlc
    zoom-us
    unstable.catt
    youtube-dl
    ghostwriter
    rtv
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      font-awesome_5
      (unstable.nerdfonts.override {
        fonts = [ "FantasqueSansMono" "FiraCode" "SourceCodePro" ];
      })
      roboto
      roboto-mono
      roboto-slab
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "roboto-mono" ];
        sansSerif = [ "roboto" ];
        serif = [ "roboto-slab" ];
      };
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    driSupport = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ chewing ];
  };

  programs.dconf.enable = true;

  services = {
    picom = {
      enable = true;
      fade = true;
      shadow = true;
      shadowOpacity = 0.7;
      vSync = true;
    };

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
      socketActivated = true;
    };

    flatpak.enable = true;
    gnome3.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "colemak";

      enableCtrlAltBackspace = true;

      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          greeters.gtk = {
            cursorTheme = {
              name = "Vanilla-DMZ";
              package = pkgs.vanilla-dmz;
              size = 16;
            };
            iconTheme = {
              name = "Paper";
              package = pkgs.paper-icon-theme;
            };
            theme = {
              name = "Adapta-Eta";
              package = pkgs.adapta-gtk-theme;
            };
          };
          enable = true;
        };
      };
      desktopManager.xterm.enable = false;
      windowManager.i3 = {
        enable = true;
        configFile = i3-config;
        package = pkgs.i3-gaps;
      };
    };
  };

  xcursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 16;
  };

  xdg.portal.enable = true;

}
