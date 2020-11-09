{ config, pkgs, lib, rootDir, ... }:
let
  userSecrets = config.vars.secrets.users.mschuwalow;
  home-manager-script = config.vars.home-manager-script;
in {
  users.users.mschuwalow = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "disk"
      "audio"
      "video"
      "networkmanager"
      "systemd-journal"
      "docker"
    ];
    createHome = true;
    home = "/home/mschuwalow";
    initialHashedPassword = userSecrets.password;
    packages = with pkgs; [ home-manager ];
  };
}
