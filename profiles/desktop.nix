{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    appimage-run
    bitwarden
    catt
    ghostwriter
    gnome3.gnome-disk-utility
    gnome3.gnome-system-monitor
    gnome3.gnome-tweak-tool
    gnome3.gnome-session
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
    usbutils
    vlc
    xclip
    xdotool
    youtube-dl
    zoom-us
    yaru-theme
    gnomeExtensions.unite
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
    flatpak.enable = true;
    gnome = {
      gnome-online-accounts.enable = true;
      gnome-online-miners.enable = true;
    };
    xserver = {
      desktopManager.gnome.enable = true;
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
