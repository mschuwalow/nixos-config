{ stdenv, lib, fetchzip, cups, tree }:

stdenv.mkDerivation {
  pname = "cups-kyocera-ecosys";
  version = "8.1606";

  dontPatchELF = true;
  dontStrip = true;

  src = fetchzip {
    # this site does not like curl -> override useragent
    curlOpts = "-A ''";
    url = "https://cdn.kyostatics.net/dlc/eu/driver/all/linux_8_1606_ecosys.-downloadcenteritem-Single-File.downloadcenteritem.tmp/Linux_8.1606_EC...P2x35~40dnw.zip";
    sha256 = "10crxdfj62ini70vv471445zi6q0l9fmg2jsd74sp6fr0qa0kvr7";
  };

  installPhase = ''
    mkdir -p $out/share/cups/model/Kyocera
    cp ./EU/English/*.PPD $out/share/cups/model/Kyocera
  '';

  meta = with lib; {
    description = "CUPS drivers for Kyocera Ecosys printers.";
    homepage = "https://dlc.kyoceradocumentsolutions.eu/index/service/dlc.false.driver.ECOSYSP2040DN._.EN.html#";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
