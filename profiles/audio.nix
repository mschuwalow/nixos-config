{ pkgs, config, ... }: {

  environment.systemPackages = with pkgs; [ pavucontrol ];

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}
