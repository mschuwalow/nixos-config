self: super: {
  ibus-engines = super.ibus-engines // {
    chewing = with super.pkgs;
      let
        version = "1.6.1";
        src = fetchFromGitHub {
          owner = "definite";
          repo = "ibus-chewing";
          rev = "c1e7f0d97aa8bb1a1166621c3f0780daa0db06c1";
          sha256 = "1q8ajfmmbg350x1p286qa38ypn391yr6xcldnyyim7km1aczipci";
        };

        cmakeFedoraSrc = fetchgit {
          url = "https://pagure.io/cmake-fedora.git";
          rev = "7d5297759aef4cd086bdfa30cf6d4b2ad9446992";
          sha256 = "0mx9jvxpiva9v2ffaqlyny48iqr073h84yw8ln43z2avv11ipr7n";
        };
      in stdenv.mkDerivation {
        inherit version;
        pname = "ibus-chewing";

        srcs = [ src cmakeFedoraSrc ];
        sourceRoot = src.name;

        nativeBuildInputs = [ pkgconfig cmake gob2 git gnumake ];

        buildInputs = [ pcre libchewing ibus gtk3 ];

        postUnpack = ''
          chmod u+w -R ${cmakeFedoraSrc.name}
          mv ${cmakeFedoraSrc.name}/* source/cmake-fedora
        '';

        preConfigure = ''
          # cmake script needs ./Modules folder to link to cmake-fedora
          ln -s cmake-fedora/Modules ./
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
