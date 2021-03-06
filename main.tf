# https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine
resource vsphere_virtual_machine "VM" {

  name       = local.name
  annotation = local.annotation
  folder     = local.folder

  boot_delay                 = 2500
  wait_for_guest_net_timeout = 0

  memory     = local.memory
  num_cpus   = local.cpus

  # CLOUDINIT DATA FOR OVF DATASOURCE
  dynamic "vapp" {
    for_each = local.vapp_properties != null ? [local.vapp_properties] : []
    content {
      properties = vapp.value
    }
  }

  # CLOUDINIT DATA FOR VMWARE GUESTINFO DATASOURCE
  extra_config = {
    "guestinfo.metadata.encoding" = "gzip+base64"
    "guestinfo.userdata.encoding" = "gzip+base64"
    "guestinfo.metadata"          = local.metadata != null ? base64gzip(local.metadata) : ""
    "guestinfo.userdata"          = local.userdata != null ? base64gzip(local.userdata) : ""
  }

  disk {
    label            = "disk0"
    size             = local.disk
    eagerly_scrub    = data.vsphere_virtual_machine.TEMPLATE.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.TEMPLATE.disks.0.thin_provisioned
  }

  network_interface {
    network_id   = data.vsphere_network.MAIN.id
    adapter_type = data.vsphere_virtual_machine.TEMPLATE.network_interface_types.0
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.TEMPLATE.id
  }

  firmware         = data.vsphere_virtual_machine.TEMPLATE.firmware
  scsi_type        = data.vsphere_virtual_machine.TEMPLATE.scsi_type
  guest_id         = data.vsphere_virtual_machine.TEMPLATE.guest_id
  resource_pool_id = data.vsphere_compute_cluster.MAIN.resource_pool_id
  datastore_id     = data.vsphere_datastore.MAIN.id
}
