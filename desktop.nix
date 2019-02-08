{ pkgs, options, config, lib, ... }:

{
  environment.systemPackages = with pkgs; [
  	gnome3.dconf
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "colemak";

    displayManager.sddm = {
      enable = true;
      #wayland = false;
    };
    desktopManager.plasma5.enable = true;
  };

  services.flatpak.enable = true;

  sound.enable = true;

  hardware.opengl = {
    enable = config.services.xserver.enable;
    driSupport32Bit = true;
  };

  hardware.pulseaudio = {
    enable = config.services.xserver.enable;
    support32Bit = true;
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
