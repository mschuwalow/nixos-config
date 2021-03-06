{ config, pkgs, ... }: {
  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
      checkJournalingFS = false;
      kernelModules = [ ];
    };
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/66042217-88cf-48e1-97a3-ccaae73e539b";
      fsType = "f2fs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6554-78D0";
      fsType = "vfat";
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  imports = [ ../profiles/gaming.nix ];

  networking.hostName = "mschuwalow-desktop";

  powerManagement.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];

  swapDevices =
    [{ device = "/dev/disk/by-uuid/12b2d777-9cdd-4f78-a6b3-e98d7ce15cd0"; }];

  system.stateVersion = "20.09";

  time.hardwareClockInLocalTime = true;
}
