{ pkgs, secrets, ... }: {
  environment.systemPackages = with pkgs; [ openvpn ];

  services = {
    openvpn.servers = {
      pureVPN = {
        config = "config ${secrets.vpn.pureVPNConfig}";
        autoStart = false;
        updateResolvConf = false;
      };
    };
  };
}
