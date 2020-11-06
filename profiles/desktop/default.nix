{ pkgs, ... }:
{
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
    spotify
    spotify-tui
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
    vlc
    zoom-us
    catt
    youtube-dl
    ghostwriter
    rtv
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      font-awesome_5
      (nerdfonts.override {
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

  imports = [
      ./i3
  ];

  services = {
    flatpak.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "colemak";
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