{ pkgs ? import <nixpkgs> { } }:

{
  nur = import ./nur.nix { inherit pkgs; };
  oni = pkgs.callPackage ./oni { };
  rocketchat = pkgs.callPackage ./rocketchat.nix { };
  niv = pkgs.callPackage ./niv.nix { };
  discord = pkgs.callPackage ./discord.nix { };
  lorri = pkgs.callPackage ./lorri.nix { };
  git-heatmap = pkgs.callPackage ./git-heatmap { };
}
