self: super:
let
  args = {
    version = "460.27.04";
    sha256_64bit = "plTqtc5QZQwM0f3MeMZV0N5XOiuSXCCDklL/qyy8HM8=";
    settingsSha256 = "hU9J0VSrLXs7N14zq6U5LbBLZXEIyTfih/Bj6eFcMf0=";
    persistencedSha256 = "PmqhoPskqhJe2FxMrQh9zX1BWQCR2kkfDwvA89+XALA=";
  };
in {
  linuxPackages = super.linuxPackages.extend
    (linuxPackagesSelf: linuxPackagesSuper: {
      nvidia_x11 = linuxPackagesSuper.callPackage
        (import <nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix> args)
        { };
    });
  linuxPackages_latest = super.linuxPackages_latest.extend
    (linuxPackagesSelf: linuxPackagesSuper: {
      nvidia_x11 = linuxPackagesSuper.callPackage
        (import <nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix> args)
        { };
    });
}
