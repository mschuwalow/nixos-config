{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.drop-down-terminal
    gnomeExtensions.gsconnect
    unstable.gnomeExtensions.material-shell
    gnome3.gnome-tweak-tool
    gnome3.dconf-editor
    gnome-firmware-updater
  ];

  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji rime ];
    };
  };

  services = {
    xserver = {
      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
