output "proxmox_node" {
  description = "The Primary Proxmox node name"
  value       = var.proxmox_node
}

output "network_gateway" {
  description = "Network gateway"
  value       = var.gateway
}

output "network_nameservers" {
  description = "DNS servers"
  value       = var.network_nameservers
}

output "default_storage" {
  description = "Default storage pool"
  value       = var.default_storage
}

output "iso_storage" {
  description = "ISO storage pool"
  value       = var.iso_storage
}

output "default_vm_settings" {
  description = "Default VM settings"
  value = {
    cpu    = local.default_vm_cpu
    memory = local.default_vm_memory
    disk   = local.default_vm_disk
  }
}