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

data vsphere_resource_pool "MAIN" {
  datacenter_id = data.vsphere_datacenter.MAIN.id
  name          = local.resourcepool
}

data vsphere_virtual_machine "TEMPLATE" {
  datacenter_id = data.vsphere_datacenter.MAIN.id
  name          = local.template
}
