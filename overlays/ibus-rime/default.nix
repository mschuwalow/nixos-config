self: super: {
  ibus-engines = super.ibus-engines // {
    rime = with super.pkgs;
      stdenv.mkDerivation rec {
        pname = "ibus-rime";
        version = "1.4.0";

        src = fetchFromGitHub {
          owner = "rime";
          repo = "ibus-rime";
          rev = version;
          sha256 = "0zbajz7i18vrqwdyclzywvsjg6qzaih64jhi3pkxp7mbw8jc5vhy";
        };

        patches = [ ./fix-paths.patch ];

        nativeBuildInputs = [ pkgconfig cmake ];

        buildInputs = [ ibus libnotify librime ];

        postPatch = ''
          # set compiled-in DATA_DIR so resources can be found
          substituteInPlace rime_config.h \
            --replace '#define IBUS_RIME_SHARED_DATA_DIR IBUS_RIME_INSTALL_PREFIX "/share/rime-data"' \
                      '#define IBUS_RIME_SHARED_DATA_DIR "${brise}/share/rime-data"' \
            --replace '#define IBUS_RIME_ICONS_DIR IBUS_RIME_INSTALL_PREFIX "/share/ibus-rime/icons"' \
                      '#define IBUS_RIME_ICONS_DIR "${
                        placeholder "out"
                      }/share/ibus-rime/icons"'
        '';

        cmakeFlags = [ "-DRIME_DATA_DIR=${brise}/share/rime-data" ];

        installPhase = ''
          runHook preInstall
          make --directory .. install PREFIX=$out builddir=$(pwd)
          runHook postInstall
        '';

        postInstall = ''
          substituteInPlace \
            $out/share/ibus/component/rime.xml \
            --replace '/usr/lib/ibus-rime' $out/libexec \
            --replace '/usr/share' $out/share
        '';

        meta = with stdenv.lib; {
          isIbusEngine = true;
          description = "IBus interface to the libpinyin input method";
          license = licenses.gpl2;
          maintainers = with maintainers; [ ericsagnes ];
          platforms = platforms.linux;
        };
      };
  };
}
