{ config, pkgs, secrets, ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    authorizedKeysFiles = secrets.sshAuthorizedKeyFiles;
  };
}
