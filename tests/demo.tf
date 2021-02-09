locals {
  vm_list = {
    vm1 = {
      name          = "vm1-demo"
      datacenter    = "Helvetesporten"
      datastore     = "vmc1-csv-testing2"
      network       = "VL309 Application Test"
      cluster       = "VMC1"
      template      = "ubuntu-focal-20.04-cloudimg"
      metadata_file = "ubuntu-metadata.yaml"
      address       = "10.42.109.100/24"
      gateway       = "10.42.109.1"
    }
  }
}

module "VM" {
  source   = "../."
  for_each = local.vm_list
  # --
  name       = each.value.name
  datacenter = each.value.datacenter
  datastore  = each.value.datastore
  network    = each.value.network
  cluster    = each.value.cluster
  template   = each.value.template
  metadata   = templatefile("${path.module}/${each.value.metadata_file}", {
    HOSTNAME = each.value.name,
    ADDRESS  = each.value.address,
    GATEWAY  = each.value.gateway,
  })
  userdata = data.cloudinit_config.USERDATA.rendered
  # --
  vapp_enabled  = true
  vapp_hostname = "ovf-kickstart"
  vapp_password = "SuperSecret"
  vapp_userdata = data.cloudinit_config.KICKSTART.rendered
}


# EXAMPLE USERDATA
data cloudinit_config "USERDATA" {
  gzip          = false # encoded/gzipped by module
  base64_encode = false # encoded/gzipped by module

  # Main user-data part
  part {
    content_type = "text/cloud-config"
    content = <<-EOH
      #cloud-config 
      ---
      timezone: Europe/Oslo
      users:
      - default
      - name: demo
        gecos: demo description
        lock_passwd: false
        groups: sudo, users, admin
        shell: /bin/bash
        sudo: ['ALL=(ALL) NOPASSWD:ALL']
        #ssh_authorized_keys:
        #- ssh-rsa some ssh-key(s)
      system_info: 
        default_user:
          name: ubuntu
          lock_passwd: false
          sudo: ["ALL=(ALL) NOPASSWD:ALL"]
      chpasswd:
        list:
        - $${USERNAME}:SuperSecret123!
        expire: false
      ssh_pwauth: false # Allow pwd to access ssh
      disable_root: true # Enable root ssh access
      random_seed:
        file: /dev/urandom
        command: ["pollinate", "-r", "-s", "https://entropy.ubuntu.com"]
        command_required: true
      packages:
      - nfs-kernel-server
      write_files:
      - content: |
          Congratulations! File created
        path: /tmp/cloud-config-done.txt
        owner: root
        permissions: '0640'
      runcmd:
      - [ "mkdir", "-p", "/opt/example" ]
      - [ "echo", "Hello from runcmd", ">>", "/tmp/cloud-config-done.txt"]
      final_message: "$DATASOURCE: The system is up, after $UPTIME seconds!"
      ...
      EOH
    filename     = "init.cfg"
  }

  # Add multiple blocks if required (up to userdata api-request limit)
  # Scripts will be executed
  part {
    content_type = "text/x-shellscript"
    content = <<-EOH
      #!/usr/bin/env bash
      echo "Hello from the first script" >> /tmp/info.txt
      EOH
    filename = "script-1.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content = <<-EOH
      #!/usr/bin/env bash
      echo "Hello from the second script" >> /tmp/info.txt
      EOH
    filename = "script-2.sh"
  }
}

# EXAMPLE KICKSTART USERDATA
data cloudinit_config "KICKSTART" {
  gzip          = false
  base64_encode = false

  # Main user-data part
  part {
    content_type = "text/cloud-config"
    content = <<-EOH
      #cloud-config
      ---
      chpasswd:
        list:
        - admin:SecurePassword
        expire: false
      users:
      - default
      - name: admin
        gecos: Admininstrator
        lock_passwd: false
        groups: sudo, users, admin
        shell: /bin/bash
        sudo: ['ALL=(ALL) NOPASSWD:ALL']
        #ssh_authorized_keys:
        #- ssh-rsa xxx
      system_info: 
        default_user:
          name: ubuntu
          lock_passwd: false
          sudo: ["ALL=(ALL) NOPASSWD:ALL"]
      ssh_pwauth: false # Allow pwd to access ssh
      disable_root: true # Enable root ssh access
      random_seed:
        file: /dev/urandom
        command: ["pollinate", "-r", "-s", "https://entropy.ubuntu.com"]
        command_required: true
      package_upgrade: true
      packages:
      - python3-pip
      write_files:
      - content: |
          ---
          network: {config: disabled}
          ...
        path: /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
        owner: root
        permissions: '0644'
      - content: |
          ---
          network:
            version: 2
            ethernets:
              ens192:
                dhcp4: false
                addresses:
                - 10.42.109.100/24
                gateway4: 10.42.109.1
                nameservers:
                  addresses: 1.1.1.1
          ...
        path: /etc/netplan/99-kickstart-ens192.yaml
        owner: root
        permissions: '0644'
      runcmd:
      - netplan apply # Enable new network settings
      - echo "blacklist floppy" | sudo tee /etc/modprobe.d/blacklist-floppy.conf && sudo rmmod floppy && sudo update-initramfs -u # Remove floppy /dev/fd0 (delays boot)
      - curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh - # Install vmware cloud-init datasource (guestinfo)
      - rm /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg && rm /etc/netplan/99-kickstart-ens192.yaml # Allow next cloud-init to manage network w/metadata
      power_state:
        timeout: 15 # Seconds before rebooting, after cloud-init finishes
        mode: reboot
      ...
      EOH
    filename     = "init.cfg"
  }
}