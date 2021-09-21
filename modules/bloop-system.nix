{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bloop-system;
in
{
  options.services.bloop-system = {
    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "-J-Xmx2G" "-J-XX:MaxInlineLevel=20" "-J-XX:+UseParallelGC" ];
      description = ''
        Specifies additional command line argument to pass to bloop
        java process.
      '';
    };

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to install a user service for the Bloop server.
        The service must be manually started for each user with
        "systemctl --user start bloop".
      '';
    };

    javaPackage = mkOption {
      type = types.package;
      default = config.programs.java.package;
      description = ''
        Java package to use.
      '';
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [ pkgs.bloop ];

    systemd.services.bloop = {
      description = "Bloop Scala build server";
      wantedBy = [ "multi-user.target" ];
      environment = { PATH = mkForce "${makeBinPath [ cfg.javaPackage ]}"; };
      serviceConfig = {
        ExecStart = "${pkgs.bloop}/bin/bloop server ${strings.concatStringsSep " " cfg.extraOptions}";
        Group = "bloop";
        RuntimeDirectoryMode = "775";
        StandardOutput = "journal";
        StandardError = "journal";
        SyslogIdentifier = "bloop";
        Type = "simple";
      };
    };

    users.groups.bloop = { };
  };
}
