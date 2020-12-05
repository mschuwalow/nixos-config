self: super: {
  cups-kyodialog3 = super.cups-kyodialog3.overrideAttrs (oldAttrs: rec {
    src = super.fetchzip {
      url =
        "https://www.kyoceradocumentsolutions.us/content/download-center-americas/us/drivers/drivers/Kyocera_Linux_PPD_Ver_8_1601_tar_gz.download.gz#Kyocera_Linux_PPD_Ver_${oldAttrs.version}.tar.gz";
      sha256 = "11znnlkfssakml7w80gxlz1k59f3nvhph91fkzzadnm9i7a8yjal";
    };
  });
}
