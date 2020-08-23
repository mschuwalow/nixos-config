let
  fetchChannel = { rev, sha256 }:
    fetchTarball {
      inherit sha256;
      url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
    };
  pkgs = import (fetchChannel {
    rev = "5d3fd3674a66c5b1ada63e2eace140519849c967";
    sha256 = "1yjn56jsczih4chjcll63a20v3nwv1jhl2rf6rk8d8cwvb10g0mk";
  }) { overlays = [ (import ./overlays/python-manylinux.nix) ]; };
in (pkgs.buildFHSUserEnv {

  name = "aim";

  targetPkgs = pkgs:
    with pkgs; [
      # Python
      (python36.withPackages
        (ps: with ps; [ pip setuptools virtualenv tkinter ]))
      (python35.withPackages
        (ps: with ps; [ pip setuptools virtualenv tkinter ]))

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
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8
  '';

}).env
