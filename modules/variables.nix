{ lib, ... }: {
  options = {
    vars = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
