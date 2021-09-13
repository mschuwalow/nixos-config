{ ... }: {
  age.secrets = {
    ovpn-purevpn = {
      name = "vpn/purevpn.ovpn";
      file = ./vpn/purevpn.ovpn.age;
    };
    ovpn-purevpn-key = {
      name = "vpn/purevpn.key";
      file = ./vpn/purevpn.key.age;
    };
    pw-mschuwalow = {
      name = "pw-mschuwalow";
      file = ./users/mschuwalow.age;
    };
    pw-pzhang = {
      name = "pw-pzhang";
      file = ./users/pzhang.age;
    };
    pw-root = {
      name = "pw-root";
      file = ./users/root.age;
    };
    ssh-github = {
      name = "ssh/github_rsa";
      file = ./ssh/github_rsa.age;
    };
    cachix = {
      name = "cachix.dhall";
      file = ./cachix.dhall.age;
    };
    nm-liveintent = {
      name = "nm/LiveIntent.nmconnection";
      file = ./nm/LiveIntent.nmconnection.age;
    };
    nm-vpn-liveintent = {
      name = "nm/LiveIntent-VPN.nmconnection";
      file = ./nm/LiveIntent-VPN.nmconnection.age;
    };
    nm-wifi-home = {
      name = "nm/KabelBox-2FF0.nmconnection";
      file = ./nm/KabelBox-2FF0.nmconnection.age;
    };
  };
}
