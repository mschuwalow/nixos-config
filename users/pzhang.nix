{ config, pkgs, lib, ... }: {
  users.users.pzhang = {
    description = "Peixun Zhang";
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
    passwordFile = config.age.secrets.pw-pzhang.path;
    packages = with pkgs; [ home-manager ];
  };
}
