self: super: {
  throttled = super.throttled.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = [ self.module_init_tools ];
  });
}
