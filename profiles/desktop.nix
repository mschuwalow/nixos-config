{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    unstable.alacritty
    unstable.google-chrome
    unstable.spotify
    spotify-tui
    bitwarden
    seafile-client
    unstable.ferdi
    screenkey
    usbutils
    xclip
    transmission-gtk
    nmap-graphical
    vlc
    zoom-us
    catt
    youtube-dl
    ghostwriter
    rtv
    okular
    hunspell
    hunspellDicts.de-de
    hunspellDicts.en-us
    xdotool
    libreoffice-fresh
    appimage-run
    gnome3.gnome-system-monitor
  ];

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [ "FantasqueSansMono" "FiraCode" "SourceCodePro" ];
      })
      roboto
      roboto-mono
      roboto-slab
      twitter-color-emoji
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
    flatpak.enable = true;
    pantheon.contractor.enable = true;
    xserver = {
      desktopManager.pantheon.enable = true;
      displayManager.lightdm.enable = true;
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "us";
      # xkbVariant = "colemak";
    };
  };

  xcursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 16;
  };

  xdg.portal.enable = true;
}
