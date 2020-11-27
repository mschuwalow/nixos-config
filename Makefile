PROJECT_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: fmt

fmt:
	nixfmt $$(find ${PROJECT_DIR} -type f -name '*.nix' ! -path "${PROJECT_DIR}checkouts/*")
