{ pkgs, ... }:
let secrets = import ../secrets;
in {
  environment.systemPackages = with pkgs; [ openvpn ];

  services = {
    openvpn.servers = {
      pureVPN = {
        config = "config ${secrets.files}/vpn/pureVPN.ovpn";
        autoStart = false;
        updateResolvConf = false;
      };
    };
  };
}
