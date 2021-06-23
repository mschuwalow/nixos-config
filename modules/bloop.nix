{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.bloop;
in
{
  options = {
    services.bloop = {
      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example =
          [ "-J-Xmx2G" "-J-XX:MaxInlineLevel=20" "-J-XX:+UseParallelGC" ];
        description = ''
          Specifies additional command line argument to pass to bloop
          java process.
        '';
      };

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable this module.
        '';
      };

      bloopPackage = mkOption {
        type = types.package;
        default = pkgs.bloop;
        description = ''
          Bloop package to use.
        '';
      };

      javaPackage = mkOption {
        type = types.package;
        default = pkgs.openjdk8;
        description = ''
          Java package to use.
        '';
      };
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = [ cfg.bloopPackage ];

    systemd.user.services.bloop = {
      Unit = { Description = "Bloop Scala build server"; };

      Service = {
        Environment = [ "PATH=${makeBinPath [ cfg.javaPackage ]}" ];
        ExecStart = "${cfg.bloopPackage}/bin/bloop server ${
            strings.concatStringsSep " " cfg.extraOptions
          }";
        StandardOutput = "journal";
        StandardError = "journal";
        SyslogIdentifier = "bloop";
      };

      Install = { WantedBy = [ "multi-user.target" ]; };
    };
  };
}
