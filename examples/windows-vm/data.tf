data cloudinit_config "USERDATA" {
  for_each = local.vm_list_windows
  # --
  gzip          = false # Compressed by module
  base64_encode = false # Encoded by module

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/init-userdata.yaml", {
      HOSTNAME = each.value.name,
      USERNAME = each.value.username,
      PASSWORD = each.value.password,
    })
    filename     = "init.cfg"
  }
  
  part {
    content_type = "text/x-shellscript"
    filename     = "network.ps1"
    content      = templatefile("${path.module}/files/script-network.ps1", {
      ADDRESS = each.value.address,
      NETMASK = each.value.netmask,
      GATEWAY = each.value.gateway,
      DNS     = each.value.dns,
    })
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/script-openssh.ps1")
    filename     = "openssh.ps1"
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/script-bginfo.ps1")
    filename     = "bginfo.ps1"
  }
}