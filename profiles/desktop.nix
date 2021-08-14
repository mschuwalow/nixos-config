{ pkgs, lib, ... }: {
  environment.systemPackages = (with pkgs; [
    appimage-run
    bitwarden
    ghostwriter
    hunspell
    hunspellDicts.de-de
    hunspellDicts.en-us
    libreoffice-fresh
    nmap-graphical
    okular
    screenkey
    spotify
    transmission-gtk
    ferdi
    google-chrome
    firefox
    alacritty
    usbutils
    vlc
    xclip
    xdotool
    zoom-us
    yaru-theme
    authy
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
      ubuntu_font_family
      (nerdfonts.override { fonts = [ "Hack" ]; })
      (unstable.iosevka.override {
        privateBuildPlan = {
          family = "Iosevka Custom";
          spacing = "normal";
          serifs = "slab";
          ligations = {
            inherits = "haskell";
            disables = [ "slasheq" ];
            enables = [ "exeq" ];
          };
          variants.design = {
            asterisk = "penta-low";
          };
          widths.normal = {
            shape = 500;
            menu = 5;
            css = "normal";
          };
        };
        set = "custom";
      })
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Twitter Color Emoji" ];
        monospace = [ "Ubuntu Mono" ];
        sansSerif = [ "Ubuntu" ];
        serif = [ "Ubuntu Condensed" ];
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
          extraGSettingsOverrides = ''
            [org.gnome.desktop.interface]
            gtk-theme='Yaru-dark'
            icon-theme='Yaru'
            cursor-theme='Yaru'
            font-name='Ubuntu 11'                                                                                                                 
            document-font-name='Ubuntu Condensed 11'                                                                                                          
            monospace-font-name='Ubuntu Mono 10'                                                                                                  
            
            [org.gnome.desktop.sound]
            theme-name='Yaru'

            [org/gnome/desktop/wm/preferences]
            titlebar-font='Ubuntu Bold 11'

            [desktop.ibus.panel.emoji]
            hotkey=[]

            [org/gnome/desktop/input-sources]
            xkb-options=['terminate:ctrl_alt_bksp', 'lv3:ralt_switch', 'compose:caps']

            [org/gnome/gedit/preferences/editor]
            scheme='Yaru-dark'
          '';
          extraGSettingsOverridePackages = with pkgs.gnome; [
            gedit
          ];
        };
        xterm.enable = false;
      };
      displayManager.gdm.enable = true;
      enable = true;
      layout = "us";
    };
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };
}
