{ pkgs, ... }:
let
  secrets = import ../secrets;
in
{
  environment.systemPackages = with pkgs; [
    openvpn
  ];

  services = {
    openvpn.servers = {
      workVPN = {
        config = "config ${secrets.workVPNFile}";
        autoStart = false;
        updateResolvConf = true;
      };
      pureVPN = {
        config = "config ${secrets.pureVPNFile}";
        autoStart = false;
        updateResolvConf = false;
      };
    };
  };
}
