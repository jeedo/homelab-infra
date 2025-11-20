terraform {
  source = "../../modules/ubuntu-server"
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    vm_name        = "foo-server"
    vm_id          = 201
    vm_template    = "ubuntu-22.04-template"
    vm_cores       = 2
    vm_memory      = 2048
    vm_disk_size   = "20G"
    vm_ip_address  = local.common_vars.inputs.foo_ip_address
    vm_gateway     = local.common_vars.inputs.gateway
    vm_user        = "ubuntu"
    ssh_public_key = local.common_vars.inputs.ssh_public_key
  }
)
