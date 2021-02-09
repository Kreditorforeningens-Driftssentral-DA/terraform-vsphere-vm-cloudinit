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

variable cluster {
  description = "(Required) vSphere cluster"
  type        = string
}

variable template {
  description = "(Required) vSphere VM template; requires vmware cloud-init datasource installed (https://github.com/vmware/cloud-init-vmware-guestinfo)"
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

variable metadata {
  description = "(Optional) Cloud-init metadata, in plain text. Encoded & gzipped by module."
  type        = string
  default     = null
}

variable userdata {
  description = "(Optional) Cloud-init userdata, in plain text. Encoded & gzipped by module."
  type        = string
  default     = null
}

variable vapp_userdata {
  description = "(Optional) vApp user-data in plain text. Encoded by module."
  type        = string
  default     = null
}
