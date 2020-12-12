{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [ spotifyd spotify-tui ];

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  sound.enable = true;
}
