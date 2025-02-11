provider "vsphere" {
  user           = "administrator@vsphere.thesre.cn"
  password       = "123456"
  vsphere_server = "vsphere.thesre.cn"

  allow_unverified_ssl = true
}