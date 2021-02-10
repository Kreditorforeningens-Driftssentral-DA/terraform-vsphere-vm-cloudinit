
terraform { required_version = ">= 0.13" }

# ===============================================
# CREATE LINUX RESOURCES IN VSPHERE
# ===============================================

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
