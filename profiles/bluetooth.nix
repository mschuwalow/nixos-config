{ pkgs, ... }: {
  hardware.bluetooth.enable = true;
  # services.blueman.enable = true;
  # environment.systemPackages = with pkgs; [ obexftp obexfs bluedevil ];
}
