{ pkgs ? import <nixpkgs> {} }:

{
  oni = pkgs.callPackage ./oni {};
  rocketchat = pkgs.callPackage ./rocketchat {};
  niv = pkgs.callPackage ./niv {};
  discord = pkgs.callPackage ./discord {};
  lorri = pkgs.callPackage ./lorri {};
}
