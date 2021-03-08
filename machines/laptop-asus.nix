{ config, pkgs, ... }: {
  imports = [ ../profiles/bluetooth.nix ];

  environment = {
    systemPackages = (with pkgs; [ fusuma powertop ]);
    etc."modprobe.d/iwlwifi.conf".text = ''
      options iwlwifi remove_when_gone=1
    '';
  };

  networking.hostName = "mschuwalow-laptop-asus";

  boot = {
    initrd = {
      checkJournalingFS = false;
      kernelModules = [ "i915" ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "acpi_osi='!Windows 2012'"
    ];
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
    powerDownCommands = ''
      ${pkgs.kmod}/bin/lsmod | ${pkgs.gnugrep}/bin/grep -q "^iwlwifi" && ${pkgs.kmod}/bin/modprobe -r -v iwlwifi
    '';
    resumeCommands = ''
      ${pkgs.kmod}/bin/modprobe -v iwlwifi
    '';
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

  system.stateVersion = "20.09";

  nix = {
    maxJobs = 8;
    buildCores = 4;
  };
}
