# CHANGELOG
## v0.1.1 (Unreleased)
#### BREAKING CHANGES
  * Replaced default metadata-variables (ip-address/gateway) with new variable "metadata". Added examples in template-dir for metadata and userdata instead.
  * Replaced variable/vsphere resource for resourcepool with cluster resource
#### IMPROVEMENTS
  * Added support for vApp configuration (ovf-datasource). This can be used for cloud-init by itself, or for bootstrapping guestinfo datasource installation. See example userdata (kickstart) in templates-folder.
#### DOCUMENTATION
  * Updated examples in README to include multi-part userdata via Terraform