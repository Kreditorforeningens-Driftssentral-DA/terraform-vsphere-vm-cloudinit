# ===============================================
# CREATE WINDOWS RESOURCES IN VSPHERE
# ===============================================

module "vm_windows" {
  for_each = local.vm_list_windows
  source   = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  version  = "0.2.0"
  #source  = "../../."
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
  # CloudBase-Init - VMware GuestInfo datasource
  metadata = templatefile("${path.module}/files/init-metadata.yaml", {HOSTNAME = each.value.name})
  userdata = data.cloudinit_config.USERDATA[each.key].rendered
}
