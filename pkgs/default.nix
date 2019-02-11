{ pkgs ? import <nixpkgs> {} }:

{
  oni = pkgs.callPackage ./oni { };
  rocketchat = pkgs.callPackage ./rocketchat {};
}
