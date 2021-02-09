# CHANGELOG
## v0.1.1 (2021-02-09)
#### BREAKING CHANGES
  * (v0.1.0) Replaced default metadata-variables (ip-address/gateway) with new variable "metadata". Added examples in template-dir for metadata and userdata instead.
  * (v0.1.0) Replaced variable/vsphere resource for resourcepool with cluster resource
#### IMPROVEMENTS
  * Added CHANGELOG
  * Added support for vApp configuration (ovf-datasource). This can be used for cloud-init by itself, or for bootstrapping guestinfo datasource installation. See example userdata (kickstart) in templates-folder.
  * guestinfo userdata/metadata now optional (due to ovf added as optional datasource)
#### DOCUMENTATION
  * Updated examples in README to include multi-part userdata via Terraform
