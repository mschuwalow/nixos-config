let
fetchChannel = { rev, sha256 }: fetchTarball {
  inherit sha256;
  url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
};
fetchPkgs = { rev, sha256, owner ? "NixOS" }: fetchTarball {
  inherit sha256;
  url = "https://github.com/${owner}/nixpkgs/archive/${rev}.tar.gz";
};
in
{
  stable = fetchChannel {
    rev = "1fc591f9a5bd1b016b5d66dfab29560073955a14";
    sha256 = "1ij5x1qw486rbih7xh2c01s60c3zblj6ad1isf5y99sh47jcq76c";
  };

  unstable = fetchPkgs {
    rev = "b8243d104f63e83eb7bf799e89a5d93d0a2edeac";
    sha256 = "0skj5d3syj5vrqh1ly9fnyc6950lr91h994x6yrnl61gb0ni4vds";
  };

  steam = fetchPkgs {
    rev = "87e35a1439392f66f8234f18bc7f3c0999ddf91d";
    sha256 = "179f0dbvsfhqx5jjsg51yv1wbqc6an2c9dfqm4icczvbjls78c9r";
    owner = "nyanloutre";
  };

  sublime = fetchPkgs {
    rev = "b321e40e1173ac320060dfd6be086ca841a84742";
    sha256 = "1sf8i0x4qrh6dmyaar89pp7zp6b7qp78wfaz29kr35ml4xdz3rka";
    owner = "zookatron";   
  };
  
}