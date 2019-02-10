{ pkgs, options, config, lib, ... }:

{
  environment.systemPackages = with pkgs; [
  	gnome3.dconf
    gnome3.gnome-disk-utility
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "colemak";

    enableCtrlAltBackspace = true;

    displayManager.sddm = {
      enable = true;
    };
    desktopManager.plasma5.enable = true;
  };

  services.flatpak.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    driSupport = true;
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      fantasque-sans-mono
      source-code-pro
      fira-code
      roboto
      roboto-mono
      roboto-slab
    ];
    fontconfig = {
      penultimate.enable = true;
      ultimate.enable = false;
      defaultFonts = {
        monospace = [ "roboto-mono" ];
        sansSerif = [ "roboto" ];
        serif = [ "roboto-slab" ];
      };
    };
  };
}
