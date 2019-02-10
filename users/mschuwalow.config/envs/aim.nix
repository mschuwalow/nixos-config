let
  pkgs = import (builtins.fetchGit {
    name = "nixos-20190210";
    url = "https://github.com/nixos/nixpkgs/";
    rev = "5ee412944c83ec689c1261745b1036de4ea5cd12";
  }) { overlays = [ (import ~/envs/overlays/python36-manylinux.nix) ]; };

in
(pkgs.buildFHSUserEnv {

  name = "aim";
  
  targetPkgs = pkgs: with pkgs; [
    # Python
    python36
    python36.pkgs.virtualenv

    # Python manylinux1 requirements
    which
    gcc
    binutils
    ncurses
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libICE
    xorg.libSM
    glib

    # Extra python stuff
    gfortran
    liblapack
    blas
    swig

    # JVM
    jre
    jdk
    maven
    
    idea.idea-ultimate
    git
  ];

  profile = ''
    unset SOURCE_DATE_EPOCH
  '';

}).env