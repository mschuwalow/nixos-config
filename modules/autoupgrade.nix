{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.autoUpgradeCheckout;
in {
  options.system.autoUpgradeCheckout = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to periodically upgrade NixOS to the latest
        version. If enabled, a systemd timer will run
        <literal>nixos-rebuild switch --upgrade</literal> once a
        day. The checkout out repo will be pulled before rebuilding.
      '';
    };

    repoPath = mkOption {
      type = types.str;
      default = "/etc/nixos";
      description = "Path to the local checkout";
    };

    allowReboot = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Reboot the system into the new generation instead of a switch
        if the new generation uses a different kernel, kernel modules
        or initrd than the booted system.
      '';
    };

    dates = mkOption {
      default = "04:40";
      type = types.str;
      description = ''
        Specification (in the format described by
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>) of the time at
        which the update will occur.
      '';
    };

    randomizedDelaySec = mkOption {
      default = "0";
      type = types.str;
      example = "45min";
      description = ''
        Add a randomized delay before each automatic upgrade.
        The delay will be chozen between zero and this value.
        This value must be a time span in the format specified by
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>
      '';
    };

    sshKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The ssh key to use for updating the checkout";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.nixos-upgrade-checkout = {
      description = "NixOS Upgrade (Checkout)";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig.Type = "oneshot";

      environment = config.nix.envVars // {
        inherit (config.environment.sessionVariables) NIX_PATH;
        HOME = "/root";
      } // config.networking.proxy.envVars;

      path = with pkgs; [
        coreutils
        gnutar
        xz.bin
        gzip
        gitMinimal
        openssh
        config.nix.package.out
        config.system.build.nixos-rebuild
      ];

      script = let
        setup-ssh = if cfg.sshKey != null then ''
          eval "$(ssh-agent)"
          ssh-add ${cfg.sshKey}
        '' else
          "";
        update-checkout = ''
          git -C ${cfg.repoPath} pull
          git -C ${cfg.repoPath} submodule update --recursive --remote  
        '';
        commit-changes = ''
          git -C ${cfg.repoPath} commit -am "autoupgrade - $(date -u --rfc-3339=seconds)" || echo "No changes to commit"
          git -C ${cfg.repoPath} push
        '';
        nixos-rebuild = "${cfg.repoPath}/nixos-rebuild";
        rebuild-with-reboot = ''
          ${setup-ssh}
          ${update-checkout}
          ${nixos-rebuild} boot
          ${commit-changes}
          booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
          built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"
          if [ "$booted" = "$built" ]; then
            ${nixos-rebuild} switch
          else
            /run/current-system/sw/bin/shutdown -r +1
          fi
        '';
        rebuild-without-reboot = ''
          ${setup-ssh}
          ${update-checkout}
          ${nixos-rebuild} switch
          ${commit-changes}
        '';

      in if cfg.allowReboot then
        rebuild-with-reboot
      else
        rebuild-without-reboot;

      startAt = cfg.dates;
    };

    systemd.timers.nixos-upgrade.timerConfig.RandomizedDelaySec =
      cfg.randomizedDelaySec;

  };
}
