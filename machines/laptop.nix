{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  imports = [ ../profiles/bluetooth.nix ];

  environment.systemPackages = [ nvidia-offload ]
    ++ (with pkgs; [ thunderbolt libinput fusuma powertop ]);

  networking.hostName = "mschuwalow-laptop";

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      rtl8192eu
    ];
    initrd = {
      checkJournalingFS = false;
      kernelModules = [ "i915" ];
    };
    loader.systemd-boot.enable = true;
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "msr.allow_writes=on" ];
  };

  hardware = {
    trackpoint.enable = true;
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
    nvidia.prime.offload.enable = true;
    firmware = with pkgs; [ sof-firmware ];
  };

  services = {
    # fprintd.enable = true;
    hardware.bolt.enable = true;
    throttled = {
      enable = true;
      extraConfig = ''
        [GENERAL]
        # Enable or disable the script execution
        Enabled: True
        # SYSFS path for checking if the system is running on AC power
        Sysfs_Power_Path: /sys/class/power_supply/AC*/online
        # Auto reload config on changes
        Autoreload: True

        ## Settings to apply while connected to Battery power
        [BATTERY]
        # Update the registers every this many seconds
        Update_Rate_s: 30
        # Max package power for time window #1
        PL1_Tdp_W: 29
        # Time window #1 duration
        PL1_Duration_s: 28
        # Max package power for time window #2
        PL2_Tdp_W: 44
        # Time window #2 duration
        PL2_Duration_S: 0.002
        # Max allowed temperature before throttling
        Trip_Temp_C: 85
        # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
        cTDP: 0
        # Disable BDPROCHOT (EXPERIMENTAL)
        Disable_BDPROCHOT: False

        ## Settings to apply while connected to AC power
        [AC]
        # Update the registers every this many seconds
        Update_Rate_s: 5
        # Max package power for time window #1
        PL1_Tdp_W: 44
        # Time window #1 duration
        PL1_Duration_s: 28
        # Max package power for time window #2
        PL2_Tdp_W: 44
        # Time window #2 duration
        PL2_Duration_S: 0.002
        # Max allowed temperature before throttling
        Trip_Temp_C: 95
        # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
        HWP_Mode: True
        # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
        cTDP: 0
        # Disable BDPROCHOT (EXPERIMENTAL)
        Disable_BDPROCHOT: False

        # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)! 
        [UNDERVOLT.BATTERY]
        # CPU core voltage offset (mV)
        CORE: 0
        # Integrated GPU voltage offset (mV)
        GPU: 0
        # CPU cache voltage offset (mV)
        CACHE: 0
        # System Agent voltage offset (mV)
        UNCORE: 0
        # Analog I/O voltage offset (mV)
        ANALOGIO: 0

        # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)!
        [UNDERVOLT.AC]
        # CPU core voltage offset (mV)
        CORE: 0
        # Integrated GPU voltage offset (mV)
        GPU: 0
        # CPU cache voltage offset (mV)
        CACHE: 0
        # System Agent voltage offset (mV)
        UNCORE: 0
        # Analog I/O voltage offset (mV)
        ANALOGIO: 0

        # [ICCMAX.AC]
        # # CPU core max current (A)
        # CORE: 
        # # Integrated GPU max current (A)
        # GPU: 
        # # CPU cache max current (A)
        # CACHE: 

        # [ICCMAX.BATTERY]
        # # CPU core max current (A)
        # CORE: 
        # # Integrated GPU max current (A)
        # GPU: 
        # # CPU cache max current (A)
        # CACHE: 
      '';
    };
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
    xserver.libinput.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };

  powerManagement.enable = true;

  system.stateVersion = "20.09";

  nix = {
    maxJobs = 16;
    buildCores = 8;
  };
}
