variable linux_vm {
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
    gateway    = string
    dns        = list(string)

  })
  default = {
    name       = "vm1"
    datacenter = "some-datacenter"
    datastore  = "some-datastore"
    network    = "some-network"
    cluster    = "VMC1"
    template   = "ubuntu-focal-20.04-cloudimg"
    address    = "192.168.10.50/24"
    gateway    = "192.168.10.1"
    dns        = ["1.1.1.1", "8.8.8.8"]
  }
}

