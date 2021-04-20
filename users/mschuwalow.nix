{ config, pkgs, lib, inputs, ... }: {
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
      "wireshark"
      "input"
    ];
    createHome = true;
    home = "/home/mschuwalow";
    passwordFile = "/run/secrets/pw-mschuwalow";
    packages = with pkgs; [ inputs.home-manager.defaultPackage."${system}" ];
  };
}
