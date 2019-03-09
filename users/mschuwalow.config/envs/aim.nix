let
  pkgs = import (builtins.fetchGit {
    name = "nixos-20190210";
    url = "https://github.com/nixos/nixpkgs/";
    rev = "2d3455ec0e3c272fcad9b207b6262f15d86f1ad2";
  }) { overlays = [ (import ./overlays/python-manylinux.nix) ]; };

in
(pkgs.buildFHSUserEnv {

  name = "aim";
  
  targetPkgs = pkgs: with pkgs; [
    # Python
    python36
    python36.pkgs.virtualenv
    python36.pkgs.tkinter

    python35
    python35.pkgs.virtualenv
    python35.pkgs.tkinter

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
    thrift

    # JVM
    jre
    jdk
    ammonite
    maven
    docker
    
    idea.idea-ultimate
    adapta-gtk-theme
    paper-icon-theme
    git
  ];

  profile = ''
    unset SOURCE_DATE_EPOCH
  '';

}).env