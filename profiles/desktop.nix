{ pkgs, lib, ... }: {
  environment.systemPackages = (with pkgs; [
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
    brave
    alacritty
    usbutils
    vlc
    xclip
    xdotool
    youtube-dl
    zoom-us
    yaru-theme
    germinal
  ]) ++ (with pkgs.gnome; [
    gnome-disk-utility
    gnome-system-monitor
    gnome-tweak-tool
    gnome-session
    dconf-editor
  ]) ++ (with pkgs.gnomeExtensions; [
    unite
    clipboard-indicator
    gtk-title-bar
    gsconnect
    caffeine
  ]);

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      twitter-color-emoji
      roboto
      roboto-slab
      roboto-mono
      ubuntu_font_family
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

  networking.firewall = {
    allowedTCPPorts = [ 57621 ]; # spotify
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # kde-connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # kde-connect
    ];
  };

  services = {
    flatpak.enable = true;
    xserver = {
      desktopManager = {
        gnome = {
          enable = true;
          extraGSettingsOverridePackages = with pkgs; [ germinal ];
          extraGSettingsOverrides = ''
            [org.gnome.desktop.interface]
            gtk-theme='Yaru-dark'
            icon-theme='Yaru'
            cursor-theme='Yaru'

            font-name='Ubuntu 11'                                                                                                                 
            document-font-name='Sans 11'                                                                                                          
            monospace-font-name='Ubuntu Mono 10'                                                                                                  
            
            [org.gnome.desktop.sound]
            theme-name='Yaru'

            [org/gnome/desktop/wm/preferences]
            titlebar-font='Ubuntu Bold 11'

            [org.gnome.Germinal]
            decorated=true
            font='FiraCode Nerd Font 10'
            forecolor='#eff0eb'
            backcolor='#16171d'
            palette=['#282a36', '#ff5c57', '#5af78e', '#f3f99d', '#57c7ff', '#ff6ac1', '#9aedfe', '#f1f1f0', '#686868', '#ff5c57', '#5af78e', '#f3f99d', '#57c7ff', '#ff6ac1', '#9aedfe', '#eff0eb']
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
