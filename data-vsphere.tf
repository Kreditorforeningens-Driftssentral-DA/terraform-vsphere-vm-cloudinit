# EXTERNAL RESOURCES
data vsphere_datacenter "MAIN" {
  name = local.datacenter
}

data vsphere_datastore "MAIN" {
  datacenter_id = data.vsphere_datacenter.MAIN.id
  name          = local.datastore
}

data vsphere_network "MAIN" {
  datacenter_id = data.vsphere_datacenter.MAIN.id
  name          = local.network
}

data vsphere_compute_cluster "MAIN" {
  datacenter_id = data.vsphere_datacenter.MAIN.id
  name          = local.cluster
}

data vsphere_virtual_machine "TEMPLATE" {
  datacenter_id = data.vsphere_datacenter.MAIN.id
  name          = local.template
}
