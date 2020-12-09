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
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    initrd = {
      checkJournalingFS = false;
      kernelModules = [ "i915" ];
    };
    loader.systemd-boot.enable = true;
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelModules = [ "acpi_call" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "intel_pstate=disable" ];
  };

  hardware = {
    trackpoint.enable = true;
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
    nvidia.prime.offload.enable = true;
    firmware = with pkgs; [ sof-firmware ];
  };

  services = {
    xserver.libinput.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;

        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";

        CPU_SCALING_MIN_FREQ_ON_AC = 0;
        CPU_SCALING_MAX_FREQ_ON_AC = 4900000;
        CPU_SCALING_MIN_FREQ_ON_BAT = 0;
        CPU_SCALING_MAX_FREQ_ON_BAT = 3500000;

        # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
        # A value of 0 disables, >=1 enables power saving (recommended: 1).
        # Default: 0 (AC), 1 (BAT)
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;

        # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
        # Default: on (AC), auto (BAT)
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";

        # Battery feature drivers: 0=disable, 1=enable
        # Default: 1 (all)
        NATACPI_ENABLE = 1;
        TPACPI_ENABLE = 1;
        TPSMAPI_ENABLE = 1;
      };
    };
    upower.enable = true;
    throttled.enable = true;
    #fprintd.enable = true;
    hardware.bolt.enable = true;
    udev.extraHwdb = ''
      libinput:name:*SynPS/2 Synaptics TouchPad:dmi:*svnLENOVO:*:pvrThinkPadP15s*
       LIBINPUT_ATTR_PRESSURE_RANGE=15:10
       LIBINPUT_ATTR_PALM_PRESSURE_THRESHOLD=150
       ID_INPUT_WIDTH_MM=100
       ID_INPUT_HEIGHT_MM=68
       LIBINPUT_ATTR_SIZE_HINT=100x68
    '';
  };

  system.stateVersion = "20.09";

  nix = {
    maxJobs = 16;
    buildCores = 8;
  };
}
