{ config, pkgs, ... }: {
  imports = [ ../profiles/bluetooth.nix ];

  environment = {
    systemPackages = with pkgs; [ fusuma powertop ];
    etc."modprobe.d/iwlwifi.conf".text = ''
      options iwlwifi remove_when_gone=1
    '';
  };

  networking.hostName = "mschuwalow-laptop-asus";

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
      luks.devices."luks-5f3a2359-fe58-4def-83a7-bf6e294bf897".device =
        "/dev/disk/by-uuid/5f3a2359-fe58-4def-83a7-bf6e294bf897";
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "acpi_osi='!Windows 2012'" ];
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

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  powerManagement = {
    enable = true;
    # powerDownCommands = ''
    #   ${pkgs.kmod}/bin/lsmod | ${pkgs.gnugrep}/bin/grep -q "^iwlwifi" && ${pkgs.kmod}/bin/modprobe -r -v iwlwifi
    # '';
    # resumeCommands = ''
    #   ${pkgs.kmod}/bin/modprobe -v iwlwifi
    # '';
  };

  services = {
    xserver.libinput.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";
        CPU_BOOST_ON_BAT = 0;
        PCIE_ASPM_ON_BAT = "powersave";
        RUNTIME_PM_ON_BAT = "on";
      };
    };
    upower.enable = true;
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/49855816-cc2e-48ac-980f-78afbd408ce1";
    encrypted = {
      enable = true;
      keyFile = "/mnt-root/root/swap.key";
      label = "luksswap";
      blkDev = "/dev/disk/by-uuid/463224aa-2e55-4d8a-9434-49862af0cd57";
    };
  }];

  system.stateVersion = "20.09";

  nix = {
    maxJobs = 8;
    buildCores = 4;
  };
}
