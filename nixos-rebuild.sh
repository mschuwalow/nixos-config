#!/usr/bin/env bash
cd "$(dirname "$0")"
export NIX_PATH="nixpkgs=./checkouts/nixpkgs:nixos-config=./configuration.nix"
exec nixos-rebuild "$@"
