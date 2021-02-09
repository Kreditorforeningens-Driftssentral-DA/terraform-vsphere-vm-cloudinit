# terraform-vsphere-vm-cloudinit

vSphere virtual machine provisioning, with Cloud-Init. This module has some restrictions,
but aims to be easy to customize for your own needs.

## Deploys single Virtual Machines to your vSphere environment

This Terraform module deploys single virtual machine, with following limitations:

- Cloned from vm-template
  - Requires cloud-init datasource for vSphere pre-installed
  - Only single HDD supported
  - Only single NIC supported
  - Target NIC is "ens192", by default
  - No custom dns by default
  - Static IP, by default

> Note: Only Linux OS is supported by the VMware cloud-init datasource

## GETTING STARTED

```hcl

# Example use of module, without customization
# Defaults:
# - hostname: "VM1"
# - cpu: 1
# - memory: 1024 MiB
# - disk: 20 GiB
module "VM1" {
  source  = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  version = "0.1.0"
  # -- Required
  name         = "VM1"
  datacenter   = "some-datacenter"
  datastore    = "some-datastore"
  network      = "some-network"
  resourcepool = "VMC1/Resources"
  template     = "ubuntu2004"
  metadata     = file("my-metadata-file.yml")
  userdata     = file("my-userdata-file.yml")
}

# Example use of module, with some customization
module "VM2" {
  source  = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  version = "0.0.1"
  # -- Required
  name         = "Custom-VM2"
  datacenter   = "some-datacenter"
  datastore    = "some-datastore"
  network      = "some-network"
  resourcepool = "VMC1/Resources"
  template     = "ubuntu2004"
  # -- Cloud-init files
  metadata = templatefile("some-metadata-templatefile.yml", {
    IP  = "192.168.10.100/24",
    GW  = "192.168.10.1",
    DNS = "[\"1.1.1.1\", \"8.8.8.8\"]"
  })
  userdata = file("some-userdata-file.yml")
  # -- VM Customization
  hostname   = "VM2"
  annotation = "Custom VM"
  cpus       = 2
  memory     = 4096
  disk       = 100
}

```

## MULTI-PART USERDATA WITH TERRAFORM
You can create the userdata with Terraform
```hcl
module "VM1" {
  source   = "Kreditorforeningens-Driftssentral-DA/vm-cloudinit/vsphere"
  # ...
  userdata = data.cloudinit_config.EXAMPLE.rendered
  # ...
}

data cloudinit_config "EXAMPLE" {
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
      - name: someuser
        gecos: someuser description
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
        - someuser:somesecretpassword
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
```
## Contributing

Any help is appreciated

## Authors

Originally created by [Rune Rønneseth](https://github.com/runeron)

## License

[MIT](LICENSE)