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
  imports = [ ./profiles/bluetooth.nix ];

  environment.systemPackages = [ nvidia-offload ];

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
    #kernelParams = [ "acpi_backlight=native" ];
  };

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
    nvidia.prime.offload.enable = true;
  };

  services = {
    xserver.libinput.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
    tlp.enable = true;
    fstrim.enable = true;
    throttled.enable = true;
  };

  system.stateVersion = "20.09";

  nix = {
    maxJobs = 16;
    buildCores = 8;
  };
}
