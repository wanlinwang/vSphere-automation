# 获取 vSphere 数据中心
data "vsphere_datacenter" "dc" {
  name = "Datacenter 01"
}

# 获取 vSphere 资源池
data "vsphere_resource_pool" "pool" {
  name          = "Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# 获取 vSphere 数据存储
data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# 获取 vSphere 网络
data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# 获取 vSphere Windows Server 2022 Cloudbase 模板
data "vsphere_virtual_machine" "template" {
  name          = "WinServer 2022 Cloud"
  datacenter_id = data.vsphere_datacenter.dc.id
}
