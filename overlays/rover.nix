pkgs: oldPkgs:
with oldPkgs; {
  rover = stdenv.mkDerivation rec {
    pname = "rover";
    version = "1.0.1";
    src = fetchFromGitHub {
      rev = "2ec364f923b60b8b1e68ffe4c705b82d9a487056";
      owner = "lecram";
      repo = "rover";
      sha256 = "00bd9j0wi36szq1zs3gqpljgznn39qh3d1yyqx25vx81jcvp357c";
    };

    buildInputs = [ ncurses ];

    buildPhase = ''
      make rover
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp rover $out/bin
      mkdir -p $out/share/man/man1
      cp rover.1 $out/share/man/man1
    '';

    meta = with stdenv.lib; {
      description = "Rover is a file browser for the terminal.";
      maintainers = with maintainers; [ mschuwalow ];
      platforms = [ "x86_64-linux" ];
      license = licenses.publicDomain;
      homepage = "https://github.com/lecram/rover";
    };
  };
}
