GNUMAKEFLAGS := --no-print-directory

.PHONY: all network cleanup

.DEFAULT_GOAL = help

export TERRAFORM = terraform

## Provision all infrastructure layers
all:
	$(MAKE) network


## Provision network layer infrastructure (VPC)
network:
	make -C network create-network


## Destroy all infrastructure layers and cleanup everything
cleanup:
	@make -C network cleanup


## Show help screen.
help:
	@echo "Please use \`make <target>' where <target> is one of\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
