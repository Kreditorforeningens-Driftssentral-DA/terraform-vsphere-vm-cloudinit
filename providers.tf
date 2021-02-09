terraform {
  required_version = ">= 0.13"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 1.24.3"
    }
    #cloudinit = {
    #  source =  "hashicorp/cloudinit"
    #  version = "~> 2.1.0"
    #}
  }
}