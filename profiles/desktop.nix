{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    appimage-run
    bitwarden
    catt
    ghostwriter
    hunspell
    hunspellDicts.de-de
    hunspellDicts.en-us
    libreoffice-fresh
    nmap-graphical
    okular
    rtv
    screenkey
    transmission-gtk
    ferdi
    google-chrome
    alacritty
    germinal
    usbutils
    vlc
    xclip
    xdotool
    youtube-dl
    zoom-us
    yaru-theme
    gnome.gnome-disk-utility
    gnome.gnome-system-monitor
    gnome.gnome-tweak-tool
    gnome.gnome-session
    gnome.dconf-editor
    gnomeExtensions.unite
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.gtktitlebar
  ];

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs;
      [
        (nerdfonts.override {
          fonts = [ "FantasqueSansMono" "FiraCode" "SourceCodePro" ];
        })
      ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Twitter Color Emoji" ];
        monospace = [ "Roboto Mono" ];
        sansSerif = [ "Roboto" ];
        serif = [ "Roboto Slab" ];
      };
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    driSupport = true;
  };

  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji rime ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 57621 ]; # spotify

  services = {
    flatpak = {
      enable = true;
      guiPackages = lib.mkForce [ ];
    };
    xserver = {
      desktopManager = {
        gnome = {
          enable = true;
          extraGSettingsOverridePackages = with pkgs; [ germinal ];
          extraGSettingsOverrides = ''
            [org.gnome.desktop.interface]
            cursor-theme='Yaru'
            gtk-theme='Yaru-dark'
            icon-theme='Yaru'

            [org.gnome.desktop.sound]
            theme-name='Yaru'

            [org.gnome.Germinal]
            decorated=true
            font='FiraCode Nerd Font 10'
            forecolor='#eff0eb'
            backcolor='#16171d'
            palette=['#282a36', '#ff5c57', '#5af78e', '#f3f99d', '#57c7ff', '#ff6ac1', '#9aedfe', '#f1f1f0', '#686868', '#ff5c57', '#5af78e', '#f3f99d', '#57c7ff', '#ff6ac1', '#9aedfe', '#eff0eb']
          '';
        };
        xterm.enable = false;
      };
      displayManager.gdm.enable = true;
      enable = true;
      layout = "us";
      # xkbVariant = "colemak";
    };
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };
}
