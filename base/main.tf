# This file contains shared infrastructure that services depend on 


locals {
  environment = "homelab"
  managed_by  = "terraform"

  # Common VM Settings
  default_vm_cpu    = 2
  default_vm_memory = 2048
  default_vm_disk   = "20G"
}
