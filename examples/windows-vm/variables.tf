variable windows_vm {
  type = object({
    name       = string
    datacenter = string
    datastore  = string
    network    = string
    cluster    = string
    template   = string
    username   = string
    password   = string
    address    = string
    netmask    = string
    gateway    = string
    dns        = string

  })
  default = {
    name       = "win1"
    datacenter = "some-datacenter"
    datastore  = "some-datastore"
    network    = "some-network"
    cluster    = "VMC1"
    template   = "w2k19desktop-cloudbase"
    username   = "SomeUser"
    password   = "$ecretP@ssword"
    address    = "192.168.10.50/24"
    netmask    = "24"
    gateway    = "192.168.10.1"
    dns        = "1.1.1.1,8.8.8.8"
  }
}

