{ pkgs, config, ... }:

{
  environment = {
    etc = {
      "NetworkManager/system-connections/KabelBox-2FF0.nmconnection" = {
        source = config.age.secrets.nm-wifi-home.path;
      };
      "NetworkManager/system-connections/LiveIntent.nmconnection" = {
        source = config.age.secrets.nm-liveintent.path;
      };
      "NetworkManager/system-connections/LiveIntent-VPN.nmconnection" = {
        source = config.age.secrets.nm-vpn-liveintent.path;
      };
      # networkmanager vpn activation will fail if file does not exist + is mutable
      "ipsec.secrets" = {
        text = "";
        mode = "0600";
      };
    };
    systemPackages = with pkgs; [
      dnsutils
      etherape
      ettercap
      openvpn
      tcpdump
      wireshark
    ];
  };

  networking = {
    networkmanager.insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall.enable = true;
  };

  programs.ssh.startAgent = true;

  services = {
    avahi.enable = true;
    openvpn.servers = {
      pureVPN = {
        config = "config ${config.age.secrets.ovpn-purevpn.path}";
        autoStart = false;
        updateResolvConf = false;
      };
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
