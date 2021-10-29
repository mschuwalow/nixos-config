{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ scanmem bottles devilutionx ];

  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };


  # diablo 2 dclone filters
  networking.firewall.extraCommands = ''
    iptables -N LOG_DROP || true
    iptables -F LOG_DROP
    iptables -A LOG_DROP -j LOG --log-prefix "IPTables-Dropped: " --log-level 6
    iptables -A LOG_DROP -j DROP

    iptables -N d2r-dclone || true
    iptables -F d2r-dclone
    iptables -A d2r-dclone -d 34.93.251.115 -j ACCEPT
    iptables -A d2r-dclone -m iprange --dst-range 158.115.1.1-158.115.206.255 -j LOG_DROP
    iptables -A d2r-dclone -m iprange --dst-range 158.115.211.1-158.115.255.255 -j LOG_DROP
    iptables -A d2r-dclone -m iprange --dst-range 34.1.1.1-34.116.255.255 -j LOG_DROP
    iptables -A d2r-dclone -m iprange --dst-range 34.118.1.1-34.255.255.255 -j LOG_DROP
    iptables -A d2r-dclone -m iprange --dst-range 35.1.1.1-35.255.255.255 -j LOG_DROP
    iptables -A d2r-dclone -j RETURN
    # iptables -I OUTPUT -j d2r-dclone
  '';
}
