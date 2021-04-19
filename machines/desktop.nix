{ config, pkgs, ... }: {
  boot = {
    initrd.checkJournalingFS = false;
    kernelPackages = pkgs.linuxPackages;
    # kernelParams = [ "mem_sleep_default=deep" "initcall_debug" ];
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
    maxJobs = 12;
    buildCores = 12;
  };

  time.hardwareClockInLocalTime = true;

  powerManagement.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "20.09";
}
