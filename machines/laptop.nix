{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../common-configuration.nix
    ../profiles/bluetooth.nix
  ];

  networking.hostName = "mschuwalow-laptop";

  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [
    "intel"
  ];

  boot.kernelParams = [
    "pcie_aspm=off"
    "acpi_rev_override=1"    
  ];

  hardware.bumblebee.enable = true;
  hardware.bumblebee.connectDisplay = true;
  hardware.bluetooth.enable = true;
  services.tlp.enable = true;
  
  powerManagement.resumeCommands = "xrandr --output HDMI1 --auto --left-of DP2 --output DP2 --auto --left-of eDP1";
    
  nix = {
    maxJobs = 4;
    buildCores = 8;
  };
}
