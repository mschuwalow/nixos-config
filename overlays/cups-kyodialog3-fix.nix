self: super:
let
  platform =
    if super.stdenv.hostPlatform.system == "x86_64-linux" then "64bit"
    else if super.stdenv.hostPlatform.system == "i686-linux" then "32bit"
         else throw "Unsupported system: ${super.stdenv.hostPlatform.system}";
  region = "Global";
  debPlatform =
    if platform == "64bit" then "amd64"
    else "i386";
  debRegion = "";
in
{
  cups-kyodialog3 = super.cups-kyodialog3.overrideAttrs (oldAttrs: rec {
    src = super.fetchzip {
      url =
        "https://www.kyoceradocumentsolutions.us/content/download-center-americas/us/drivers/drivers/Kyocera_Linux_PPD_Ver_${builtins.replaceStrings ["."] ["_"] oldAttrs.version}_tar_gz.download.gz#Kyocera_Linux_PPD_Ver_${oldAttrs.version}.tar.gz";
      sha256 = "11znnlkfssakml7w80gxlz1k59f3nvhph91fkzzadnm9i7a8yjal";
    };
    installPhase = ''
      mkdir -p $out
      cd $out

      # unpack the debian archive
      ar p ${src}/KyoceraLinuxPackages/${region}/${platform}/kyodialog3.en${debRegion}_0.5-0_${debPlatform}.deb data.tar.gz | tar -xz
      rm -Rf KyoceraLinuxPackages

      # strip $out/usr
      mv usr/* .
      rmdir usr

      # allow cups to find the ppd files
      mkdir -p share/cups/model
      mv share/ppd/kyocera share/cups/model/Kyocera
      rmdir share/ppd

      # prepend $out to all references in ppd and desktop files
      find -name "*.ppd" -exec sed -E -i "s:/usr/lib:$out/lib:g" {} \;
      find -name "*.desktop" -exec sed -E -i "s:/usr/lib:$out/lib:g" {} \;
    '';
  });
}
