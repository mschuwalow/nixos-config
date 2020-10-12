{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-kyodialog3 ];
  };
}
