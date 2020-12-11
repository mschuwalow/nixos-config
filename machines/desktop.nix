{ config, pkgs, ... }: {
  boot = {
    initrd.checkJournalingFS = false;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "processor.max_cstate=1" "rcu_nocbs=0-15" "iommu=soft" ];
    kernelPatches = [{
      name = "ryzen";
      patch = null;
      extraConfig = ''
        CPU_ISOLATION y
        RCU_EXPERT y
        RCU_NOCB_CPU y
      '';
    }];
    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        memtest86.enable = true;
        useOSProber = true;
        version = 2;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  networking.hostName = "mschuwalow-desktop";

  nix = {
    maxJobs = 8;
    buildCores = 16;
  };

  time.hardwareClockInLocalTime = true;

  services.xserver = {
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr \
      --output HDMI-0 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --mode 1920x1080 --pos 3640x0 --rotate right \
      --output DP-0 --primary --mode 2560x1440 --pos 1080x0 --rotate normal \
      --output DP-1 --off \
      --output DP-2 --off \
      --output DP-3 --off \
      --output DP-4 --mode 1920x1080 --pos 0x0 --rotate left \
      --output DP-5 --off
    '';
    videoDrivers = [ "nvidia" ];
  };

  system.stateVersion = "20.09";
}
