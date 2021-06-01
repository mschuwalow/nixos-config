{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nix.cachix-hook;
  upload_to_cachix = pkgs.writeScript "upload-to-cachix" ''
    #!/bin/sh
    set -eu
    set -f # disable globbing

    # skip push if the declarative job spec
    OUT_END=$(echo ''${OUT_PATHS: -10})
    if [ "$OUT_END" == "-spec.json" ]; then
    exit 0
    fi

    export HOME=/root
    exec ${pkgs.cachix}/bin/cachix -c ${cfg.cachixConfigFilePath} push ${cfg.cacheName} $OUT_PATHS > /tmp/hydra_cachix 2>&1
  '';

in {
  options.nix.cachix-hook = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable.
      '';
    };

    cacheName = mkOption {
      type = types.str;
      description = ''
        Name of the cache to use.
      '';
    };

    cachePublicKey = mkOption {
      type = types.str;
      description = ''
        Public key of the cache.
      '';
    };

    cachixConfigFilePath = mkOption {
      type = types.path;
      default = "/run/secrets/cachix.dhall";
      description = ''
        Path of the cachix config file.
      '';
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [ pkgs.cachix ];

    nix = {
      binaryCaches = [ "https://${cfg.cacheName}.cachix.org" ];
      binaryCachePublicKeys = [ cfg.cachePublicKey ];
      extraOptions = ''
        post-build-hook = ${upload_to_cachix}
      '';
    };
  };
}
