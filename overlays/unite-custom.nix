self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    unite =
      super.gnomeExtensions.unite.overrideAttrs (old: rec {
        src = super.fetchFromGitHub {
          owner = "mschuwalow";
          repo = "unite-shell";
          rev = "b424726e6beed1a047dc19d5202292ac41861f21";
          sha256 = "fWW2O3LXb8eNJU/hOB2TfxyZ4C/yQa2NVoe5eotOOYw=";
        };
      });
  };
}
