PROJECT_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: fmt

fmt:
	fd --full-path ${PROJECT_DIR} -a -e nix -x nixfmt
