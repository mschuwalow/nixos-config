{ config, pkgs, lib, rootDir, ... }:
let
  userSecrets = config.vars.secrets.users.pzhang;
  home-manager-script = config.vars.home-manager-script;
in {
  users.users.pzhang = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "disk"
      "audio"
      "video"
      "networkmanager"
      "systemd-journal"
      "docker"
      "input"
      "wheel"
    ];
    createHome = true;
    home = "/home/pzhang";
    passwordFile = "/run/secrets/pw-pzhang";
    packages = with pkgs; [ home-manager ];
  };
}
