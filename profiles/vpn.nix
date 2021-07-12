{ config, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [ openvpn ];
    etc = {
      "NetworkManager/system-connections/LiveIntent.nmconnection" = {
        source = "/run/secrets/nm/liveintent.nmconnection";
      };
      # networkmanager vpn activation will fail if file does not exist + is mutable
      "ipsec.secrets" = {
        text = "";
        mode = "0600";
      };
    };
  };
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
