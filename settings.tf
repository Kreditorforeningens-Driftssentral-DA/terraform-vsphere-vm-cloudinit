# MODULE CONFIGURATION
locals {
  # --
  name         = var.name
  datacenter   = var.datacenter
  datastore    = var.datastore
  network      = var.network
  resourcepool = var.resourcepool
  template     = var.template
  userdata     = var.userdata
  # --
  hostname   = var.hostname != null ? var.hostname : var.name
  annotation = var.annotation
  folder     = var.folder
  ip_address = var.ip_address
  gateway    = var.gateway
  cpus       = var.cpus
  memory     = var.memory
  disk       = var.disk
}
