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

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableOnBoot = true;
    liveRestore = false;
    extraOptions = "--config-file=${daemonConfig}";
  };
}
