GNUMAKEFLAGS := --no-print-directory

.PHONY: create-network destroy-network cleanup

.DEFAULT_GOAL = help

export TERRAFORM = terraform


## Provision network layer infrastructure
all:
	$(MAKE) create-network


## Generate ssh key to ne used to access bastion host
generate-ssh-key:
	@if [ ! -d .ssh ]; then \
		mkdir .ssh; \
		ssh-keygen -q -N "" -b 4096 -f .ssh/id_rsa; \
	fi


## Cleanup ssh key
cleanup-ssh-key:
	@if [ -d .ssh ]; then \
			rm -rf .ssh; \
	fi


## Provision all VPC cloud resources.
create-network: generate-ssh-key
	$(TERRAFORM) init
	$(TERRAFORM) plan -out=tf.out -target=module.vpc
	$(TERRAFORM) apply tf.out
	$(TERRAFORM) plan -out=tf.out -target=module.public-subnets
	$(TERRAFORM) apply tf.out
	$(TERRAFORM) plan -out=tf.out -target=module.private-subnets
	$(TERRAFORM) apply tf.out
	$(TERRAFORM) plan -out=tf.out -target=module.internet-gateway
	$(TERRAFORM) apply tf.out
	$(TERRAFORM) plan -out=tf.out -target=module.nat-gateway
	$(TERRAFORM) apply tf.out
	$(TERRAFORM) plan -out=tf.out -target=module.bastion-host
	$(TERRAFORM) apply tf.out
	rm -rf tf.out


## Force destroy VPC all cloud resources without cleanup
destroy-network:
	@if [ -d .terraform ] && [ -f terraform.tfstate ]; then \
		$(TERRAFORM) destroy -auto-approve; \
	else \
		echo "No infrastructure seems to be provisioned with terraform."; \
	fi

## Remove temporary terraform files
terraform-cleanup:
	@rm -rf terraform.tfstate terraform.tfstate.backup .terraform; \
	rm -rf tf.out


## Destroy the VPC infrastructure resources and cleanup terraform temp files
cleanup:destroy-network cleanup-ssh-key terraform-cleanup


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
