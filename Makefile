.DEFAULT_GOAL := build

# Override these values if connecting to vCenter instance
export VSPHERE_USER     ?= "administrator@vsphere.local"
export VSPHERE_PASSWORD ?= "secret"

export DOCKER_IMAGE     := "tf/cloudinit:dev"

# INFO:
# Build terraform image containing module files
build: clean
	@docker ${@} -t ${DOCKER_IMAGE} .
.PHONY: build

# INFO:
# Validate terraform configuration
validate:
	@docker run --rm -it -e VSPHERE_USER=${VSPHERE_USER} -e VSPHERE_PASSWORD=${VSPHERE_PASSWORD} --name deleteme ${DOCKER_IMAGE} ${@} .
.PHONY: validate

# INFO:
# Validate terraform formatting
fmt:
	@docker run --rm -it --name deleteme ${DOCKER_IMAGE} ${@} -diff .
.PHONY: fmt

# INFO:
# Cleanup temporary files
clean:
	@docker image rm ${DOCKER_IMAGE}
.PHONY: clean
