self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    clipboard-indicator =
      super.gnomeExtensions.clipboard-indicator.overrideAttrs (old: rec {
        version = "38";
        nativeBuildInputs = with super; [ glib gettext ];
        src = super.fetchFromGitHub {
          owner = "Tudmotu";
          repo = "gnome-shell-extension-clipboard-indicator";
          rev = "v${version}";
          sha256 = "FNrh3b6la2BuWCsriYP5gG0/KNbkFPuq/YTXTj0aJAI=";
        };
      });
  };
}
