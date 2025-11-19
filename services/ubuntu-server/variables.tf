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

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "ubuntu-server"
}

variable "vm_id" {
  description = "ID of the VM"
  type        = number
  default     = 100
}

variable "vm_template" {
  description = "Template for the VM"
  type        = string
  default     = "ubuntu-22.04-template"
}

variable "vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Amount of memory (in MB) for the VM"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size for the VM (eg 20G)"
  type        = string
  default     = "20G"
}

variable "vm_ip_address" {
  description = "IP address for the VM with CIDR"
  type        = string
  default     = "192.168.0.100/24"
}

variable "vm_gateway" {
  description = "Gateway for the VM"
  type        = string
}

variable "vm_nameservers" {
  description = "Nameservers for the VM (space delimited)"
  type        = string
  default     = "8.8.8.8"
}

variable "ssh_public_key" {
  description = "SSH public key for the VM"
  type        = string
}

variable "vm_user" {
  description = "Username for the VM"
  type        = string
  default     = "ubuntu"
}