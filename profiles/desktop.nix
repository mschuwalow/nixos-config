{ pkgs, options, config, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome3.dconf
    gnome3.gnome-disk-utility
    custom.rocketchat
    spotify
    skypeforlinux

    mupdf
    rofi

    i3blocks-gaps
    i3lock
    compton    
    wirelesstools
    lm_sensors
    light
    acpi
    python3
    python3.pkgs.dbus-python
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "colemak";

    enableCtrlAltBackspace = true;

    displayManager.slim.defaultUser = "mschuwalow";
    desktopManager = {
      default = "none";
      xterm.enable = false;
      xfce = {
      	enable = true;
      	noDesktop = true;
      	enableXfwm = false;
      };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };

  programs.dconf.enable = true;

  services.flatpak.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    driSupport = true;
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      font-awesome_5
      
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
