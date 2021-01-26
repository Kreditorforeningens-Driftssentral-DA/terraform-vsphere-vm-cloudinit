# ===============================================
#  REQUIRED VARIABLES
# ===============================================

variable name {
  description = "(Required) vSphere VM-name"
  type        = string
}

variable datacenter {
  description = "(Required) vSphere datacenter"
  type        = string
}

variable datastore {
  description = "(Required) vSphere datastore"
  type        = string
}

variable network {
  description = "(Required) vSphere network"
  type        = string
}

variable resourcepool {
  description = "(Required) vSphere resourcepool"
  type        = string
}

variable template {
  description = "(Required) vSphere VM template; requires vmware cloud-init datasource installed (https://github.com/vmware/cloud-init-vmware-guestinfo)"
  type        = string
}

variable userdata {
  description = "(Required) Cloud-init userdata"
  type        = string
}

# ===============================================
#  OPTIONAL VARIABLES
# ===============================================

variable hostname {
  description = "(Optional) VM hostname. Defaults to vm name in vSphere if not set"
  type        = string
  default     = null
}

variable annotation {
  description = "(Optional) VM comment in vSphere"
  default     = "Deployed with Terraform (https://github.com/Kreditorforeningens-Driftssentral-DA/terraform-vsphere-vm-cloudinit)"
}

variable folder {
  description = "(Optional) VM folder in vSphere"
  type        = string
  default     = ""
}

variable ip_address {
  description = "(Optional) IP-address for the VM, including netmask"
  type        = string
  default     = "10.0.0.0/24"
}

variable gateway {
  description = "(Optional) Gateway address for the VM"
  type        = string
  default     = "127.0.0.1"
}

variable cpus {
  description = "(Optional) Number of cpus to assign"
  type        = number
  default     = 1
}

variable memory {
  description = "(Optional) Memory to assign, in MiB"
  type        = number
  default     = 1024
}

variable disk {
  description = "(Optional) Diskstorage to assign, in GiB"
  type        = number
  default     = 20
}
