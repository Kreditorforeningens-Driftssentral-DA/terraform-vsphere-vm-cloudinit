# terraform-vsphere-vm-cloudinit

vSphere virtual machine provisioning, with Cloud-Init. This module has some restrictions,
but aims to be easy to customize for your own needs.

## Deploys single Virtual Machines to your vSphere environment

This Terraform module deploys single virtual machine, with following limitations:

- Cloned from vm-template
  - Requires cloud-init datasource for vSphere pre-installed
  - Only single HDD supported
  - Only single NIC supported
  - Target NIC is "ens192", by default
  - No custom dns by default
  - Static IP, by default

> Note: Only Linux OS is supported by the VMware cloud-init datasource

## Getting started

```hcl

# Example use of module, without customization
# Defaults:
# - hostname: "VM1"
# - cpu: 1
# - memory: 1024 MiB
# - disk: 20 GiB
module "VM1" {
  source  = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  version = "0.0.1"
  # -- Required
  name         = "VM1"
  datacenter   = "some-datacenter"
  datastore    = "some-datastore"
  network      = "some-network"
  resourcepool = "VMC1/Resources"
  template     = "ubuntu2004"
  userdata     = file("my-userdata-file.yml")
}

# Example use of module, with some customization
module "VM2" {
  source  = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  version = "0.0.1"
  # -- Required
  name         = "Custom-VM2"
  datacenter   = "some-datacenter"
  datastore    = "some-datastore"
  network      = "some-network"
  resourcepool = "VMC1/Resources"
  template     = "ubuntu2004"
  userdata     = file("my-userdata-file.yml")
  # -- Customization
  hostname   = "VM2"
  annotation = "Custom VM"
  cpus       = 2
  memory     = 4096
  disk       = 100
}

```

## Contributing

Any help is appreciated

## Authors

Originally created by [Rune Rønneseth](https://github.com/runeron)

## License

[MIT](LICENSE)