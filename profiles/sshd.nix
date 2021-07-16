{ config, pkgs, ... }: {
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
    ];
    passwordAuthentication = false;
  };
}
