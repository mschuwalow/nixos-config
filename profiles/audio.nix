{ pkgs, config, ... }: {

  environment.systemPackages = with pkgs; [ pavucontrol ];

  hardware.pulseaudio.enable = false; # replace with pipewire

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  sound.enable = true;
}
