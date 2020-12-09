{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    alacritty
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

  imports = [
    # ./i3
    ./gnome.nix
  ];

  networking.firewall.allowedTCPPorts = [ 57621 ]; # spotify

  services = {
    flatpak.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      # xkbVariant = "colemak";
      enableCtrlAltBackspace = true;
    };
  };

  xcursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 16;
  };

  xdg.portal.enable = true;
}
