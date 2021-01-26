instance-id: ${HOSTNAME}-init
local-hostname: ${HOSTNAME}
network:
  version: 2
  renderer: networkd
  ethernets:
    ens192:
      dhcp4: false
      addresses:
        - ${ADDRESS}
      gateway4: ${GATEWAY}
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
