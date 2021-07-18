{ pkgs, ... }:

{
  environment = {
    etc = {
      "NetworkManager/system-connections/KabelBox-2FF0.nmconnection" = {
        source = "/run/secrets/nm/KabelBox-2FF0.nmconnection";
      };
      "NetworkManager/system-connections/LiveIntent.nmconnection" = {
        source = "/run/secrets/nm/LiveIntent.nmconnection";
      };
      # networkmanager vpn activation will fail if file does not exist + is mutable
      "ipsec.secrets" = {
        text = "";
        mode = "0600";
      };
    };
    systemPackages = with pkgs; [
      etherape
      ettercap
      tcpdump
      wireshark
      openvpn
    ];
  };

  networking = {
    networkmanager.insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall = { enable = true; };
  };

  programs.ssh.startAgent = true;

  services = {
    avahi.enable = true;
    openvpn.servers = {
      pureVPN = {
        config = "config /run/secrets/purevpn.ovpn";
        autoStart = false;
        updateResolvConf = false;
      };
    };
  };
}
