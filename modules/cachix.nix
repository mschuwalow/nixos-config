{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nix.cachixIntegration;
  pathPattern = "(${lib.concatStringsSep "|" cfg.autoPushPatterns})";
  upload_to_cachix = pkgs.writeScript "upload-to-cachix" ''
    #!${pkgs.bash}/bin/bash
    set -eu
    set -f # disable globbing

    paths=($OUT_PATHS)
    hits=($(printf '%s\n' "''${paths[@]}" | grep -E '${pathPattern}' || true))
    
    if [[ -v hits && ! ''${#hits[@]} -eq 0 ]]; then
      echo "Pushing to cachix: $OUT_PATHS"
      export HOME=/root
      exec ${pkgs.cachix}/bin/cachix -c ${cfg.cachixConfigFilePath} push ${cfg.cacheName} $OUT_PATHS > /tmp/cachix 2>&1 || true
    fi
  '';
in

{
  options.nix.cachixIntegration = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable.
      '';
    };

    autoPush = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Add a post-build hook that pushes to cachix.
      '';
    };

    autoPushPatterns = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Regex patterns of path names that should be pushed to the cache.
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
      extraOptions = lib.optionalString cfg.autoPush ''
        post-build-hook = ${upload_to_cachix}
      '';
    };
  };
}
