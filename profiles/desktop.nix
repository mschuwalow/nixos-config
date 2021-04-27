{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    appimage-run
    bitwarden
    catt
    ghostwriter
    gnome3.gnome-disk-utility
    gnome3.gnome-system-monitor
    gnome3.gnome-tweak-tool
    hunspell
    hunspellDicts.de-de
    hunspellDicts.en-us
    libreoffice-fresh
    nmap-graphical
    okular
    rtv
    screenkey
    transmission-gtk
    alacritty
    ferdi
    google-chrome
    spotify
    usbutils
    vlc
    xclip
    xdotool
    youtube-dl
    zoom-us
  ];

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
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

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
