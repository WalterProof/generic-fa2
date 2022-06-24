SHELL := /bin/bash

ifndef LIGO
LIGO=docker run --rm -v "$(PWD)":"$(PWD)" -w "$(PWD)" ligolang/ligo:next
endif
# ^ use LIGO en var bin if configured, otherwise use docker

help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

test = @$(LIGO) run test $(project_root) ./test/$(1)
# ^ run given test file

.PHONY: test
test: ## run tests (SUITE=single_asset make test)
ifndef SUITE
	@$(call test,single_asset.test.mligo)
	@$(call test,multi_asset.test.mligo)
else
	@$(call test,$(SUITE).test.mligo)
endif
