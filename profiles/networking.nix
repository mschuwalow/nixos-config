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

    firewall = { enable = true; };
  };
  programs.ssh.startAgent = true;
  services.avahi.enable = true;
}
