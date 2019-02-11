{ config, pkgs, ... }:
let
  secrets = import ../secrets;
in
{
  services.openssh = {
  	enable = true;
  	passwordAuthentication = false;
  	authorizedKeysFiles = secrets.sshAuthorizedKeyFiles;
  };
}
