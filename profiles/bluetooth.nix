{ pkgs, ... }: {
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [ blueman obexftp obexfs bluedevil ];
}
