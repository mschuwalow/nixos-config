{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    google-chrome
    spotify
    spotify-tui
    bitwarden
    seafile-client
    ferdi
    screenkey
    mupdf
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
      # ./i3
      ./gnome.nix
  ];

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