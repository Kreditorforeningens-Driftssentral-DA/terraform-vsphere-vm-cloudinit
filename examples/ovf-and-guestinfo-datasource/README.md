# CLOUD-INIT USING OVF & BOOTSTRAP VMWARE GUESTINFO

This example will use a template of the standard Ubuntu 20.04 cloud-image, 
run cloud-init with the included ovf datasource to install vmware
guestinfo datasource. Then it will restart the server & configure it
using this datasource (metadata & userdata)

You can deploy multiple VM's by adding them to the 'vm_list' local variable
