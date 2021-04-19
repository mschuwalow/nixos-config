{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ openvpn ];

  services = {
    openvpn.servers = {
      pureVPN = {
        config = "config /run/secrets/purevpn.ovpn";
        autoStart = false;
        updateResolvConf = false;
      };
    };
  };
}
