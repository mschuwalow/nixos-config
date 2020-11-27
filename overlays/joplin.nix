self: super:
let
  pname = "joplin-desktop";
  version = "1.4.15";
  name = "${pname}-${version}";
  src = super.fetchurl {
    url =
      "https://github.com/laurent22/joplin/releases/download/v${version}/Joplin-${version}.AppImage";
    sha256 = "12wh7f1a9sn250lqnb8c9b5gqr8r76kxrhl0kgsm2lg93jgpvvbb";
  };
  appimageContents = super.appimageTools.extractType2 { inherit name src; };
  launcher = super.writeScript "launchJoplin" ''
    ${super.appimage-run}/bin/appimage-run ${src}
  '';
in {
  joplin-desktop = super.makeDesktopItem {
    name = pname;
    desktopName = "Joplin";
    icon = "${appimageContents}/joplinapp-desktop.png";
    exec = launcher;
  };
}
