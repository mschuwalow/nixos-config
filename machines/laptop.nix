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

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      checkJournalingFS = false;
      kernelModules = [ "i915" "acpi_call" ];
    };
    loader.systemd-boot.enable = true;
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "msr.allow_writes=on" ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    # firmware = with pkgs; [ sof-firmware ];
    nvidia = {
      powerManagement.enable = false;
      prime.offload.enable = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
  };

  services = {
    fprintd.enable = true;
    hardware.bolt.enable = true;
    throttled.enable = true;
    fstrim.enable = true;
    tlp = {
      enable = false;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
    xserver = {
      libinput.enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager.gdm.nvidiaWayland = true;
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/c601ecaa-698f-45e0-8dfd-c946860db8c7";
    encrypted = {
      enable = true;
      keyFile = "/mnt-root/root/swap.key";
      label = "luksswap";
      blkDev = "/dev/disk/by-uuid/4f32d452-0e33-476e-b90c-cba4dfa90ad0";
    };
  }];

  powerManagement.enable = true;

  system.stateVersion = "20.09";
}
