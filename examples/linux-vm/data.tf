# ===============================================
# KICKSTART USERDATA (OVF)
#  - Set static ip-address
#  - Disable floppy (Ubuntu cloud-image bug)
#  - Download & enable guestinfo datasource
#  - Cleanup & reboot
# ===============================================

# When each VM has different config, we also use for_each here (same key)
data cloudinit_config "KICKSTART_LINUX" {
  for_each      = local.vm_list_linux
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content  = <<-EOH
    write_files:
    - content: |
        blacklist floppy
      path: /etc/modprobe.d/blacklist-floppy.conf
      owner: root
      permissions: '0644'
    - content: |
        network: {config: disabled}
      path: /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
      owner: root
      permissions: '0644'
    - content: |
        network:
          version: 2
          ethernets:
            ens192:
              dhcp4: false
              addresses:
              - ${each.value.address}
              gateway4: ${each.value.gateway}
              nameservers:
                addresses:
                %{~ for addr in each.value.dns ~}
                - ${addr}
                %{~ endfor ~}
      path: /etc/netplan/99-ens192.yaml
      owner: root
      permissions: '0644'
    runcmd:
    - netplan apply && rm /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg && rm /etc/netplan/99-ens192.yaml
    - curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh -
    power_state:
      timeout: 15 # Seconds before rebooting, after cloud-init finishes
      mode: reboot
    EOH
    filename = "init.cfg"
  }
}

# ===============================================
# VMWARE GUESTINFO METADATA & USERDATA
# ===============================================

# When each VM has different config, we also use for_each here (same key)
data null_data_source "METADATA_LINUX" {
  for_each = local.vm_list_linux
  inputs = {
    ubuntu = <<-EOH
    instance-id: id-${each.value.name}
    local-hostname: ${each.value.name}
    network:
      version: 2
      renderer: networkd
      ethernets:
        ens192:
          dhcp4: false
          addresses:
          - ${each.value.address}
          gateway4: ${each.value.gateway}
          nameservers:
            addresses:
            %{~ for addr in each.value.dns ~}
            - ${addr}
            %{~ endfor ~}
    EOH
  }
}

# When each VM has same config, we down't need for_each
data cloudinit_config "USERDATA_LINUX" {
  gzip          = false
  base64_encode = false

  # GENERIC USERDATA
  part {
    content_type = "text/cloud-config"
    filename = "init.cfg"
    content  = <<-EOH
    timezone: Europe/Oslo
    locale: nb_NO
    users:
    - default
    system_info: 
      default_user:
        name: ubuntu
        gecos: Ubuntu user
        shell: /bin/bash
        plain_text_passwd: ubuntu
        lock_passwd: False  # Allow local login
        sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_pwauth: False # Allow pwd to access ssh
    disable_root: True # root ssh access disabled
    final_message: "$DATASOURCE: The system is up, after $UPTIME seconds!"
    EOH
  }

  # INLINE SCRIPT
  part {
    content_type = "text/x-shellscript"
    filename     = "cloud-script-1.sh"
    content      = <<-EOH
    #!/usr/bin/env bash
    printf "Hello, stranger\n" >> /tmp/hello.txt
    EOH
  }
}
