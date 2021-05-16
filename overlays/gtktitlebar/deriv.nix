{ lib, stdenv, gnome, fetchFromGitHub, xprop, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-gtk-title-bar";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "velitasali";
    repo = "gtktitlebar";
    rev = version;
    sha256 = "EkEoWwaQmepNbZbvrwUAsYRwCU/uRrj2Oma9TyUEF6Y=";
  };

  uuid = "gtktitlebar@velitasali.github.io";

  nativeBuildInputs = [ glib ];

  buildInputs = [ xprop ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir=${uuid}/schemas/ ${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "GNOME extension that removes title bar for non-GTK software (when maximized)";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mschuwalow ];
    homepage = "https://github.com/velitasali/gtktitlebar";
    broken = versionOlder gnome.gnome-shell.version "3.28";
  };
}
