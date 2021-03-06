{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      checkJournalingFS = false;
      kernelModules = [ "i915" "kvm-intel" "acpi_call" ];
      luks.devices."luks-7030d337-7c75-47ec-903c-1a141f7d46e3".device =
        "/dev/disk/by-uuid/7030d337-7c75-47ec-903c-1a141f7d46e3";
    };
    loader.systemd-boot.enable = true;
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "msr.allow_writes=on" "psmouse.synaptics_intertouch=0" ];
  };

  environment.systemPackages = [ nvidia-offload ]
    ++ (with pkgs; [ thunderbolt libinput powertop ]);

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2032b77d-7a05-45d5-b20f-aa8d9fafdd0d";
      fsType = "f2fs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D8F7-9D4A";
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
    nvidia = {
      modesetting.enable = true;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:45:0:0";
        offload.enable = true;
      };
    };
  };

  imports = [ ../profiles/bluetooth.nix ];

  networking.hostName = "mschuwalow-laptop";

  nix = {
    maxJobs = 16;
    buildCores = 8;
  };

  services = {
    fprintd.enable = true;
    hardware.bolt.enable = true;
    throttled.enable = true;
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
