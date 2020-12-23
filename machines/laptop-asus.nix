{ config, pkgs, ... }: {
  imports = [ ../profiles/bluetooth.nix ];

  environment.systemPackages = (with pkgs; [ fusuma powertop ]);

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
    kernelPackages = pkgs.linuxPackages_latest;
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

  services = {
    xserver.libinput.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      };
    };
    upower.enable = true;
  };

  system.stateVersion = "20.09";

  nix = {
    maxJobs = 16;
    buildCores = 8;
  };
}
