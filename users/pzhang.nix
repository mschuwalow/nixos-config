{ config, pkgs, lib, ... }: {
  users.users.pzhang = {
    description = "Peixun Zhang (BB)";
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
