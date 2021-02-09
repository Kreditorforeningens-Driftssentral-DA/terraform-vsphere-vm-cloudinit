.DEFAULT_GOAL := init

# EXPORT REQUIRED ENV-VARIABLES
# 1. export VSPHERE_USER=<username>
# 2. export VSPHERE_PASSWORD=<password>
# 3. Run commands

export TF_IN_AUTOMATION   := true
export TF_INPUT           := false

export VSPHERE_ALLOW_UNVERIFIED_SSL := true
export VSPHERE_SERVER   						?= vcenter.kred.no

apply:
	@terraform init
	@terraform validate
	@terraform apply
.PHONY: apply

destroy:
	@terraform destroy
.PHONY: destroy