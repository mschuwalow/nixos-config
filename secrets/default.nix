{ ... }: {
  age = {
    secrets = {
      "purevpn.key".file = ./vpn/purevpn.key.age;
      "purevpn.ovpn".file = ./vpn/purevpn.ovpn.age;
      "pw-mschuwalow".file = ./users/mschuwalow.age;
      "pw-pzhang".file = ./users/pzhang.age;
      "pw-root".file = ./users/root.age;
      "github_rsa".file = ./ssh/github_rsa.age;
      "cachix.dhall".file = ./cachix.dhall.age;
      "nm/liveintent.nmconnection".file = ./nm/liveintent.nmconnection.age;
    };
  };
}
