#!/usr/bin/env bash
cd "$(dirname "$0")"
exec nixos-rebuild -I nixpkgs=./checkouts/nixpkgs -I nixpkgs-overlays=./overlays-compat/ -I nixos-config=./configuration.nix "$@"
