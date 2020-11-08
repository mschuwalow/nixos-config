{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ openvpn ];

  services = {
    openvpn.servers = {
      pureVPN = {
        config = "config ${config.vars.secrets.vpn.pureVPNConfig}";
        autoStart = false;
        updateResolvConf = false;
      };
    };
  };
}
