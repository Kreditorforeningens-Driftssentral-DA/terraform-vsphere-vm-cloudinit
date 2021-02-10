# MODULE CONFIGURATION
locals {
  # --
  name       = var.name
  datacenter = var.datacenter
  datastore  = var.datastore
  network    = var.network
  cluster    = var.cluster
  template   = var.template
  hostname   = var.hostname != null ? var.hostname : var.name
  annotation = var.annotation
  folder     = var.folder
  cpus       = var.cpus
  memory     = var.memory
  disk       = var.disk
  # Cloud-Init datasource settingd
  vapp_properties = var.vapp_properties
  metadata        = var.metadata
  userdata        = var.userdata
}
