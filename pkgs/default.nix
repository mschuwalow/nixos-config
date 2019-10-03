{ pkgs ? import <nixpkgs> {} }:

{
  oni = pkgs.callPackage ./oni {};
  rocketchat = pkgs.callPackage ./rocketchat.nix {};
  niv = pkgs.callPackage ./niv.nix {};
  nur = pkgs.callPackage ./nur.nix {};
  discord = pkgs.callPackage ./discord.nix {};
  lorri = pkgs.callPackage ./lorri.nix {};
  git-heatmap = pkgs.callPackage ./git-heatmap {};
}
