{ pkgs, config, ... }: {

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  sound.enable = true;
}
