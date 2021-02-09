
terraform {
    required_version = ">= 0.13"
}

# ===============================================
# CONFIGURATION FOR VM(S)
# ===============================================

locals {
  vm_list = {
    vm1 = var.vm1
    /*
    vm2 = {
      name          = "vm2"
      datacenter    = "yadi-0"
      datastore     = "yadi-1"
      network       = "yadi-2"
      cluster       = "VMC1"
      template      = "ubuntu-focal-20.04-cloudimg"
      username      = "yadi"
      password      = "yadi!!"
      address       = "192.168.10.200/24"
      gateway       = "192.168.10.1"
      dns           = ["1.1.1.1", "8.8.8.8"]
    }
    */
  }
}

# ===============================================
# CREATE RESOURCES IN VSPHERE
# ===============================================

module "VM" {
  source   = "../../."
  for_each = local.vm_list
  # --
  name       = each.value.name
  datacenter = each.value.datacenter
  datastore  = each.value.datastore
  network    = each.value.network
  cluster    = each.value.cluster
  template   = each.value.template
  # OVF datasource
  vapp_userdata = data.cloudinit_config.KICKSTART_USERDATA[each.key].rendered
  # VMware GuestInfo datasource
  metadata = data.null_data_source.METADATA[each.key].outputs["ubuntu"]
  userdata = data.cloudinit_config.USERDATA.rendered
}

# ===============================================
# KICKSTART USERDATA (OVF)
#  - Set static ip-address
#  - Install dependecies
#  - Create adminitrator account
#  - Download & enable guestinfo datasource
#  - Cleanup & reboot
# ===============================================

data cloudinit_config "KICKSTART_USERDATA" {
  for_each      = local.vm_list
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    filename = "init.cfg"
    content  = templatefile("${path.module}/templates/kickstart.yaml.j2", {
      USERNAME = each.value.username,
      PASSWORD = each.value.password,
      ADDRESS  = each.value.address,
      GATEWAY  = each.value.gateway,
      DNS      = each.value.dns,
    })
  }
}

# ===============================================
# VMWARE GUESTINFO USERDATA - MULTIPART
# ===============================================

data cloudinit_config "USERDATA" {
  gzip          = false
  base64_encode = false

  # GENERIC USERDATA
  part {
    content_type = "text/cloud-config"
    filename = "init.cfg"
    content  = file("${path.module}/templates/userdata.yaml")
  }

  # INLINE SCRIPT
  part {
    content_type = "text/x-shellscript"
    content = <<-EOH
      #!/usr/bin/env bash
      printf "Hello from script-1.sh\n" >> /tmp/cloud-config-done.txt
      EOH
    filename = "script-1.sh"
  }
}
# ===============================================
# VMWARE GUESTINFO METADATA
#   - Set hostname, assign static ip, netmask, gateway & dns
# ===============================================

data null_data_source "METADATA" {
  for_each = local.vm_list
  inputs = {
    ubuntu = templatefile("${path.module}/templates/metadata-ubuntu.yaml.j2", {
      HOSTNAME = each.value.name,
      ADDRESS  = each.value.address,
      GATEWAY  = each.value.gateway,
      DNS      = each.value.dns,
    })
  }
}
