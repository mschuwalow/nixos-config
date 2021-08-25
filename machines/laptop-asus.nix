{ config, pkgs, ... }: {

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "rtsx_usb_sdmmc"
      ];
      checkJournalingFS = false;
      kernelModules = [ "i915" "kvm-intel" ];
      luks.devices = {
        "luks-5f3a2359-fe58-4def-83a7-bf6e294bf897".device = "/dev/disk/by-uuid/5f3a2359-fe58-4def-83a7-bf6e294bf897";
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "acpi_osi='!Windows 2012'" ];
  };

  environment = {
    systemPackages = with pkgs; [ powertop ];
    etc."modprobe.d/iwlwifi.conf".text = ''
      options iwlwifi remove_when_gone=1
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5215ec1d-9b87-41ee-b272-349bf0b7365b";
      fsType = "f2fs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/7831-D54E";
      fsType = "vfat";
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  imports = [
    ../extras/bluetooth.nix
  ];

  networking.hostName = "mschuwalow-laptop-asus";

  swapDevices = [{
    device = "/dev/disk/by-uuid/49855816-cc2e-48ac-980f-78afbd408ce1";
    encrypted = {
      enable = true;
      keyFile = "/mnt-root/root/swap.key";
      label = "luksswap";
      blkDev = "/dev/disk/by-uuid/463224aa-2e55-4d8a-9434-49862af0cd57";
    };
  }];

  system.stateVersion = "21.05";
}
