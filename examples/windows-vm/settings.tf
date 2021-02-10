terraform { required_version = ">= 0.13" }

locals {
  vm_list_windows = {
    vm1 = var.windows_vm
    # Optionally add more VMs
  }
}
