{ config, lib, pkgs, ... }:

with lib;

let cfg = config.xcursor;

in {
  options.xcursor = {
    defaultCursor = mkOption {
      type = types.str;
      default = "left_ptr";
      example = "X_cursor";
      description = "The default cursor file to use within the package.";
    };
    name = mkOption {
      default = "Premium";
      type = types.string;
      description = ''
        The X cursor theme to apply.
      '';
    };
    size = mkOption {
      default = 24;
      type = types.int;
      description = ''
        The size of the cursor.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.vanilla-dmz;
      description = ''
        The package containing the theme;
      '';
    };
  };

  config = {

    environment = {
      etc."gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-cursor-theme-name=${cfg.name}
          gtk-cursor-theme-size=${toString cfg.size}
        '';
        mode = "444";
      };

      etc."gtk-2.0/gtkrc" = {
        text = ''
          gtk-cursor-theme-name=${cfg.name}
          gtk-cursor-theme-size=${toString cfg.size}          
        '';
        mode = "444";
      };

      pathsToLink = [ "/share/icons" ];

      profileRelativeEnvVars.XCURSOR_PATH =
        [ "/run/current-system/sw/share/icons" ];

      systemPackages = [
        cfg.package
        (pkgs.callPackage ({ stdenv }:
          stdenv.mkDerivation rec {
            name = "global-cursor-theme";
            unpackPhase = "true";
            outputs = [ "out" ];
            installPhase = ''
              mkdir -p $out/share/icons/default
              cat << EOF > $out/share/icons/default/index.theme
              [Icon Theme]
              Name=Default
              Comment=Default Cursor Theme
              Inherits=${cfg.name}
              EOF
            '';
          }) { })
      ];

      variables.XCURSOR_SIZE = toString cfg.size;
    };
  };
}
