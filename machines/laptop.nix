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
    ++ (with pkgs; [ thunderbolt libinput ]);

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
    tlp.enable = false;
    fstrim.enable = true;
    throttled.enable = false;
    fprintd.enable = true;
    hardware.bolt.enable = true;
    udev.extraHwdb = ''
      libinput:name:*SynPS/2 Synaptics TouchPad:dmi:*svnLENOVO*:pvrThinkPadP15sGen1*
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
