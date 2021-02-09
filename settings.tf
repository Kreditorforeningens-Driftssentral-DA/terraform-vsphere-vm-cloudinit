# MODULE CONFIGURATION
locals {
  # --
  name       = var.name
  datacenter = var.datacenter
  datastore  = var.datastore
  network    = var.network
  cluster    = var.cluster
  template   = var.template
  metadata   = var.metadata
  userdata   = var.userdata
  # -- OS
  hostname   = var.hostname != null ? var.hostname : var.name
  annotation = var.annotation
  folder     = var.folder
  cpus       = var.cpus
  memory     = var.memory
  disk       = var.disk
  # -- BETA
  vapp_enabled  = var.vapp_enabled
  vapp_hostname = var.vapp_hostname != null ? var.vapp_hostname : var.name
  vapp_password = var.vapp_password
  vapp_userdata = var.vapp_userdata
}
