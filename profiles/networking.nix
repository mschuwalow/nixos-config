{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    etherape
    ettercap
    tcpdump
    wireshark
  ];
  networking = {
    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPortRanges = [
        # KDE Connect
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        # KDE Connect
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
  programs.ssh.startAgent = true;
}
