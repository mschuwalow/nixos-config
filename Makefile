PROJECT_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
NIX_FILES   := $(shell fd --full-path ${PROJECT_DIR} -a -e nix)

.PHONY: fmt

fmt:
	@nixpkgs-fmt ${NIX_FILES}
