self: super: {

  iosevka-custom = self.unstable.iosevka.override {
    privateBuildPlan = {
      family = "Iosevka Custom";
      spacing = "normal";
      serifs = "slab";
      ligations = {
        inherits = "haskell";
        disables = [ "slasheq" ];
        enables = [ "exeq" ];
      };
      variants.design = {
        asterisk = "penta-low";
      };
      widths.normal = {
        shape = 500;
        menu = 5;
        css = "normal";
      };
    };
    set = "custom";
  };

}
