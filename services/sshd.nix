{ config, pkgs, ... }:
let
  sshDir = ../configs/ssh;
in
{
  services.openssh = {
  	enable = true;
  	passwordAuthentication = false;
  	authorizedKeysFiles = [
  	 "${sshDir}/schuwalow_rsa.pub"
  	];
  };
}
