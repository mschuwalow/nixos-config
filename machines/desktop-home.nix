{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ../profiles/gaming.nix ];

  networking.hostName = "mschuwalow-desktop-home";

  boot = {
    initrd = {
      availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
      luks.devices."luks-b3af58fe-579b-41a6-b1f9-af17408b1144".device = "/dev/disk/by-uuid/b3af58fe-579b-41a6-b1f9-af17408b1144";
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
    loader.grub = {
      enable = true;
      device = "/dev/osdisk";
      useOSProber = true;
      version = 2;
      gfxmodeBios = "1280x1024,auto";
      gfxpayloadBios = "keep";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f82ba771-1f52-43cb-9091-a1589c1b7212";
      fsType = "f2fs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/ef1dabc1-5450-4498-94b0-4dd2f621475d";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/90aaf398-b7a3-441d-887a-52b81057053a";
      encrypted = {
        enable = true;
        keyFile = "/mnt-root/root/swap.key";
        label = "luksswap";
        blkDev = "/dev/disk/by-uuid/69a7fdaf-c760-4870-bbd2-cf6592751c0e";
      };
    }
  ];

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="CT500MX500SSD1_2113E5911C84", SYMLINK+="osdisk"
    '';
    xserver.videoDrivers = [ "nvidia" ];
  };

  system.stateVersion = "21.05";
  time.hardwareClockInLocalTime = true;
}
