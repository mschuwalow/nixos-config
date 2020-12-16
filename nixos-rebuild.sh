#!/usr/bin/env bash
cd "$(dirname "$0")"
exec nixos-rebuild -I nixpkgs=./checkouts/nixpkgs -I nixpkgs-overlays -I nixos-config=./configuration.nix "$@"
