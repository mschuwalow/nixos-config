PROJECT_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: fmt

fmt:
	fd --full-path ${PROJECT_DIR} -a -e nix -x nixpkgs-fmt
