{ config, pkgs, ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    authorizedKeysFiles = config.vars.secrets.sshAuthorizedKeyFiles;
  };
}
