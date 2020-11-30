{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ cups-kyodialog3 ];
  };
}
