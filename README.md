# VSPHERE CLOUD-INIT
> Using cloud-init , you can deploy both Windows & Linux machines using the same terraform module (and workflow).

  * Linux template requires Cloud-Init (OVF/GuestInfo datasource(s) enabled)
  * Windows template requires the CloudBase-Init (OVF/GuestInfo datasource(s) enabled)

## DESCRIPTION
This Terraform module deploys a virtual machine (or multiple, using 'for_each'), with following limitations:

  * Deploys from pre-created vSphere template.
  * Single HDD supported (will add support for more if anyone requests it).
  * Single NIC supported (will add support for more if anyone requests it).
  * Not ALL fields supports customization (will add support for more if anyone requests it).

## EXAMPLES
See the 'examples' directory in the repo

```bash
# LINUX
module "vm_linux" {
  for_each = local.vm_list_linux
  source  = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  version = "0.2.0"
  # --
  name       = each.value.name
  datacenter = each.value.datacenter
  datastore  = each.value.datastore
  network    = each.value.network
  cluster    = each.value.cluster
  template   = each.value.template
  # --
  vapp_properties = {
    hostname  = "id-ovf"
    user-data = data.cloudinit_config.KICKSTART_LINUX[each.key].rendered
  }
  metadata      = data.null_data_source.METADATA_LINUX[each.key].outputs["ubuntu"]
  userdata      = data.cloudinit_config.USERDATA_LINUX.rendered
}

# WINDOWS
module "vm_windows" {
  for_each = local.vm_list_windows
  source   = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  version  = "0.2.0"
  # --
  memory = 4096
  cpus   = 2
  disk   = 40
  # --
  name       = each.value.name
  datacenter = each.value.datacenter
  datastore  = each.value.datastore
  network    = each.value.network
  cluster    = each.value.cluster
  template   = each.value.template
  # --
  metadata = templatefile("${path.module}/files/init-metadata.yaml", {HOSTNAME = each.value.name})
  userdata = data.cloudinit_config.USERDATA[each.key].rendered
}

```

## CONTRIBUTING
Any help is appreciated

## AUTHOR(S)
Originally created by [Rune Rønneseth](https://github.com/runeron)

## LICENCE
[MIT](LICENSE)