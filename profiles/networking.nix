{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    etherape
    ettercap
    networkmanager
    tcpdump
    wireshark
  ];
  networking = {
    networkmanager.enable = true;

    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 445 139 ];
      allowedUDPPorts = [ 137 138 ];
    };
  };
}
