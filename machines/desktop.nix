{ config, pkgs, ... }: {
  boot = {
    initrd.checkJournalingFS = false;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "processor.max_cstate=5" "rcu_nocbs=0-15" ];
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
    maxJobs = 16;
    buildCores = 16;
  };

  time.hardwareClockInLocalTime = true;

  powerManagement.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "20.09";
}
