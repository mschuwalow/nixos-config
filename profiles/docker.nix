{ pkgs, ... }:
let
  daemonConfig = pkgs.writeText "daemon.json" (builtins.toJSON {
    bip = "10.200.0.1/24";
    default-address-pools = [
      {
        base = "10.201.0.0/16";
        size = 24;
      }
      {
        base = "10.202.0.0/16";
        size = 24;
      }
    ];
  });
in
{
  environment.systemPackages = with pkgs; [ dive docker_compose ];

  virtualisation.libvirtd.enable = true;
  virtualisation.lxc.enable = true;
  virtualisation.lxc.usernetConfig = ''
    bfo veth lxcbr0 10
  '';

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableOnBoot = true;
    extraOptions = "--config-file=${daemonConfig}";
  };
}
