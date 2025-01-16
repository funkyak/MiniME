terraform {
  required_providers {
    proxmox = {
      source  = "danitso/Proxmox"
      version = "~> 2.9.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token
}

variable "proxmox_url" {}
variable "proxmox_api_token" {}
variable "proxmox_api_token_id" {}
variable "proxmox_node" {}
variable "proxmox_network_bridge" {}
variable "dns_server" {}
variable "domain_name" {}
variable "domain_controller_ip" {}
variable "admin_password" {}

resource "proxmox_vm_qemu" "vm" {
  count          = 10
  name           = "vm-${count.index + 1}"
  target_node    = var.proxmox_node
  clone          = "template-vm-windows10"
  cores          = 4
  memory         = 4096
  network {
    model  = "virtio"
    bridge = var.proxmox_network_bridge
  }
  disk {
    size = "20G"
  }

  # Specify a provisioner to set up DNS and join the domain
  provisioner "remote-exec" {
    inline = [
      "Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses ${var.dns_server}",
      "Add-Computer -DomainName ${var.domain_name} -Credential (New-Object System.Management.Automation.PSCredential('${var.domain_name}\\Administrator', (ConvertTo-SecureString '${var.admin_password}' -AsPlainText -Force))) -DomainController ${var.domain_controller_ip} -Restart"
    ]

    connection {
      type        = "winrm"
      host        = self.network_interface[0].ip_address
      user        = "Administrator"
      password    = var.admin_password
      https        = true                  
      insecure    = true
      port        = 5986 #(HTTP use 5985)
    }

  }
}

output "vm_ips" {
  value = [for vm in proxmox_vm_qemu.vm : vm.network_interface[0].ip_address]
}
