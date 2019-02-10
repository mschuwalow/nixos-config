{ pkgs ? import <nixpkgs> {} }:

{
  oni = pkgs.callPackage ./oni { };
}
