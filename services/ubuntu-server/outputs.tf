output "vm_id" {
  description = "The ID of the Proxmox VM"
  value       = proxmox_vm_qemu.ubuntu_server.vmid
}

output "vm_name" {
  description = "The name of the Proxmox VM"
  value       = proxmox_vm_qemu.ubuntu_server.name
}

output "vm_ip" {
  description = "The IP address of the Proxmox VM"
  value       = var.vm_ip_address
}

output "ssh_command" {
  description = "The SSH command to connect to the Proxmox VM"
  value       = "ssh ${var.vm_user}@${split("/", var.vm_ip_address)[0]}"
}