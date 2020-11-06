{ pkgs, ... }:
let i3-config = import ./i3.nix { inherit pkgs; };
in {

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ chewing ];
  };

  programs.dconf.enable = true;

  services = {
    picom = {
      enable = true;
      fade = true;
      shadow = true;
      shadowOpacity = 0.7;
      vSync = true;
    };

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
      socketActivated = true;
    };

    gnome3.gnome-keyring.enable = true;

    xserver = {
      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          greeters.gtk = {
            cursorTheme = {
              name = "Vanilla-DMZ";
              package = pkgs.vanilla-dmz;
              size = 16;
            };
            iconTheme = {
              name = "Papirus";
              package = pkgs.papirus-icon-theme;
            };
            theme = {
              name = "Plata";
              package = pkgs.plata-theme;
            };
          };
          enable = true;
        };
      };
      windowManager.i3 = {
        enable = true;
        configFile = i3-config;
        package = pkgs.i3-gaps;
      };
    };
  };
}
