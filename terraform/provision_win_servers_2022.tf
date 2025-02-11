locals {
  vm_configs = {
    "DC01" = {
      ipv4_address = "172.31.0.21"
      computer_name = "DC01"
    },
    "DC02" = {
      ipv4_address = "172.31.0.22"
      computer_name = "DC02"
    }
  }
}

resource "vsphere_virtual_machine" "win_vm" {
  for_each = local.vm_configs

  name             = "WinServer 2022 ${each.key}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = "windows2019srvNext_64Guest"

  firmware              = "efi"
  efi_secure_boot_enabled = false

  disk {
    label            = "disk0"
    size             = 100
    thin_provisioned = true
  }

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name = each.value.computer_name
        admin_password = "123456"
        auto_logon = true
      }

      network_interface {
        ipv4_address = each.value.ipv4_address
        ipv4_netmask = 12
      }

      ipv4_gateway = "172.31.0.1"

    }
  }
}
