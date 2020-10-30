{ pkgs, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
