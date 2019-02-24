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
    };
  };
}
