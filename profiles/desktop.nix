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
          extraGSettingsOverridePackages = with pkgs; [
            gsettings-desktop-schemas
            gnome.gnome-shell
            germinal
          ];
          extraGSettingsOverrides = ''
            [org/gnome/desktop/interface]
            cursor-theme='Yaru'
            gtk-theme='Yaru-dark'
            icon-theme='Yaru'

            [org/gnome/desktop/sound]
            theme-name='Yaru'

            [org/gnome/shell]
            enabled-extensions=['user-theme@gnome-shell-extensions.gcampax.github.com', 'unite@hardpixel.eu', 'clipboard-indicator@tudmotu.com']  

            [org/gnome/shell/extensions/unite]
            greyscale-tray-icons=true
            window-buttons-theme='materia-dark'

            [org/gnome/shell/extensions/user-theme]
            name='Yaru'

            [org/gnome/Germinal]
            decorated=true
            font='FiraCode Nerd Font 10'
          '';
          sessionPath = with pkgs; [ germinal ];
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
