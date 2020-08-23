self: super: {
  python36 = super.python36.overrideAttrs (oldAttrs: rec {
    postInstall = oldAttrs.postInstall
      + "echo 'manylinux1_compatible=True' >> $out/lib/python3.6/_manylinux.py";
  });

  python35 = super.python35.overrideAttrs (oldAttrs: rec {
    postInstall = oldAttrs.postInstall
      + "echo 'manylinux1_compatible=True' >> $out/lib/python3.5/_manylinux.py";
  });

}
