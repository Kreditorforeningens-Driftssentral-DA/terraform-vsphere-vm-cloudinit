.DEFAULT_GOAL := init

# EXPORT REQUIRED ENV-VARIABLES
# 1. export VSPHERE_USER=<username>
# 2. export VSPHERE_PASSWORD=<password>
# 3. export VSPHERE_SERVER=<uri>
# 3. Run commands

export VSPHERE_ALLOW_UNVERIFIED_SSL := true

export TF_IN_AUTOMATION   := true
export TF_INPUT           := false

check:
	@terraform init
	@terraform validate
.PHONY: check

apply:
	@terraform init
	@terraform validate
	@terraform apply
.PHONY: apply

destroy:
	@terraform destroy
.PHONY: destroy