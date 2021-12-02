{ config, pkgs, lib, ... }: {
  users.users.mschuwalow = {
    description = "Maxim Schuwalow";
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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC2WQH2OAYBUg4R0+6lqyrTpuQAbYom1aouAWvcE1uGZbppyvxFQNHULdVz+rO7Q1xbP+NiLwljiJC3HDJyvrTmPfmYeKW+3j5+xeFAQZ8PayJr0N6qy7UY0NiOmfgHgQQOiU9mYl443rL4nthb6BhV66idaMqBhrklDSvjWZhobgOl7CO1BtnTeFG+6mrjgj+zvhgw58uX+w84RY8mS0QowS2yDl9q5TM2yZrBOLQFz/tLKSHei64Ch4C1AVCkLTvSug7ul9Go7dTiLYD2ddyjauo+/HVUl8Y9CiBC20HP+nnEvEbYF1L8b3uLDMpnvdeGIxpdcUyV1Ax9f2t1zHd schuwalow_rsa"
    ];
    passwordFile = config.age.secrets.pw-mschuwalow.path;
    packages = with pkgs; [ home-manager ];
  };
}
