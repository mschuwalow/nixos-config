{ pkgs, lib, ... }: {
  environment = {
    #sessionVariables = {
    #  MOZ_X11_EGL = "1";
    #};
    systemPackages = (with pkgs; [
      alacritty
      appimage-run
      authy
      bitwarden
      ferdi
      firefox
      ghostwriter
      glxinfo
      google-chrome
      hunspell
      hunspellDicts.de-de
      hunspellDicts.en-us
      libreoffice-fresh
      nmap-graphical
      okular
      screenkey
      spotify
      transmission-gtk
      usbutils
      vlc
      xclip
      xdotool
      yaru-theme
      zoom-us
    ]) ++ (with pkgs.gnome; [
      dconf-editor
      gnome-disk-utility
      gnome-system-monitor
    ]);
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      twitter-color-emoji
      ubuntu_font_family
      (nerdfonts.override { fonts = [ "Hack" ]; })
      iosevka-custom
    ];
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
  };

  programs.pantheon-tweaks.enable = true;

  services = {
    flatpak.enable = true;
    xserver = {
      desktopManager = {
        pantheon.enable = true;
        xterm.enable = false;
      };
      enable = true;
      layout = "us";
    };
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };
}
