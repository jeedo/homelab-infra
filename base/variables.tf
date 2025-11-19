variable "proxmox_api_url" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox user password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Target Proxmox node name"
  type        = string
}

variable "gateway" {
  description = "Network gateway"
  type        = string
}

variable "network_nameservers" {
  description = "Network nameservers (space delimited)"
  type        = string
  default     = "8.8.8.8 8.8.4.4"
}

# Storage configuration
variable "default_storage" {
  description = "Default storage pool for VMs"
  type        = string
  default     = "local-lvm"
}

variable "iso_storage" {
  description = "Storage pool for ISO images"
  type        = string
  default     = "local"
}