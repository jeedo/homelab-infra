# homelab-infra

Infrastructure as Code for managing homelab virtual machines on Proxmox using OpenTofu and Terragrunt.

## Overview

This project provides a modular and reusable infrastructure setup for provisioning and managing virtual machines on Proxmox VE using OpenTofu (an open-source Terraform fork) and Terragrunt. The infrastructure is organized into reusable modules and service definitions, making it easy to deploy and maintain multiple VMs with consistent configurations.

### Features

- **Modular architecture**: Reusable VM modules for consistent deployments
- **Terragrunt orchestration**: Simplified multi-environment management with DRY configuration
- **Cloud-init support**: Automated VM initialization and configuration
- **Pre-commit hooks**: Automated code formatting and security scanning
- **Template-based**: Quick VM provisioning from cloud images

### Project Structure

```
homelab-infra/
├── modules/
│   └── ubuntu-server/       # Reusable Ubuntu server module
├── services/
│   ├── ubuntu-server/       # Ubuntu server service configuration
│   └── foo-server/          # Additional server configurations
├── common.hcl               # Shared configuration variables (not in git)
└── common.hcl.example       # Example configuration template
```

## Prerequisites

Before you begin, ensure you have the following installed:

- [OpenTofu](https://opentofu.io/) - Open-source Terraform fork
- [Terragrunt](https://terragrunt.gruntwork.io/) - Terraform/OpenTofu wrapper for managing infrastructure stacks
- [uv](https://uv.sh/) - Fast Python package and environment manager
- A Proxmox VE server with API access

## Getting Started

### 1. Install Development Tools

```bash
# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install pre-commit as a uv tool
uv tool install pre-commit --with pre-commit-uv

# Initialize pre-commit hooks
pre-commit install
```

### 2. Configure Pre-commit Hooks

The project includes pre-commit hooks for code quality:

```bash
# Run pre-commit hooks manually
pre-commit run -a
```

> [!NOTE]
> If there are no changes after running pre-commit, you may need to stage changes first with `git add .`

> [!TIP]
> If `tofu_fmt` fails but reports files were modified, run `pre-commit run -a` again to apply the formatting changes.

### 3. Proxmox Setup

#### Create Terraform User

Create a dedicated user for Terraform/OpenTofu in Proxmox with appropriate permissions:

1. Follow [these instructions](https://github.com/Telmate/terraform-provider-proxmox/blob/v3.0.2-rc05/docs/index.md#creating-the-proxmox-user-and-role-for-terraform) to create the `terraform-prov@pve` user
2. Grant necessary permissions for VM provisioning

#### Create Cloud-Init Template

Create an Ubuntu 22.04 cloud-init template on your Proxmox server:

```bash
# Download Ubuntu cloud image
cd /var/lib/vz/template/iso
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Create a VM (ID 9000 as template)
qm create 9000 --name ubuntu-22.04-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

# Import the cloud image as a disk
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm

# Attach the disk to the VM
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0

# Add cloud-init drive
qm set 9000 --ide2 local-lvm:cloudinit

# Set boot order
qm set 9000 --boot c --bootdisk scsi0

# Add serial console
qm set 9000 --serial0 socket --vga serial0

# Enable QEMU guest agent
qm set 9000 --agent enabled=1

# Convert the VM to a template
qm template 9000
```

#### Configure QEMU Guest Agent

Create a cloud-init snippet for automatic QEMU guest agent installation:

```bash
# Create the snippets directory (if it doesn't exist)
mkdir -p /var/lib/vz/snippets

# Create the cloud-init configuration
cat << 'EOF' > /var/lib/vz/snippets/qemu-guest-agent.yml
#cloud-config
runcmd:
  - apt-get update
  - apt-get install -y qemu-guest-agent
  - systemctl enable qemu-guest-agent
EOF
```

### 4. Configure Your Environment

1. Copy the example configuration:
   ```bash
   cp common.hcl.example common.hcl
   ```

2. Edit `common.hcl` with your specific values:
   ```hcl
   inputs = {
     proxmox_api_url   = "https://your-proxmox.local:8006/api2/json"
     proxmox_user      = "terraform-prov@pve"
     proxmox_password  = "your-secure-password"
     proxmox_node      = "your-node-name"
     gateway           = "10.0.0.1"
     ssh_public_key    = "ssh-ed25519 AAAA... user@host"
     foo_ip_address    = "10.0.0.101/24"
     ubuntu_ip_address = "10.0.0.102/24"
   }
   ```

> [!IMPORTANT]
> The `common.hcl` file contains sensitive information and is excluded from version control. Never commit this file.

## Usage

### Deploy a Service

Navigate to a service directory and run:

```bash
cd services/ubuntu-server
terragrunt apply -auto-approve
```

### Destroy a Service

```bash
cd services/ubuntu-server
terragrunt destroy -auto-approve
```

### Add a New Service

1. Create a new directory under `services/`
2. Create a `terragrunt.hcl` file using the module:
   ```hcl
   terraform {
     source = "../../modules/ubuntu-server"
   }

   locals {
     common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
   }

   inputs = merge(
     local.common_vars.inputs,
     {
       vm_name        = "my-server"
       vm_id          = 203
       vm_template    = "ubuntu-22.04-template"
       vm_cores       = 2
       vm_memory      = 2048
       vm_disk_size   = "20G"
       vm_ip_address  = "10.0.0.103/24"
       vm_gateway     = local.common_vars.inputs.gateway
       vm_user        = "ubuntu"
       ssh_public_key = local.common_vars.inputs.ssh_public_key
     }
   )
   ```
3. Run `terragrunt apply` in the new service directory

### Apply changes to all services
```bash
cd services
terragrunt run --all --non-interactive apply
```

## Module Configuration

The `ubuntu-server` module accepts the following variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `vm_name` | Name of the virtual machine | Yes |
| `vm_id` | Unique VM ID in Proxmox | Yes |
| `vm_template` | Name of the cloud-init template | Yes |
| `vm_cores` | Number of CPU cores | Yes |
| `vm_memory` | RAM in MB | Yes |
| `vm_disk_size` | Disk size (e.g., "20G") | Yes |
| `vm_ip_address` | Static IP with CIDR notation | Yes |
| `vm_gateway` | Network gateway | Yes |
| `vm_user` | Default user for cloud-init | Yes |
| `ssh_public_key` | SSH public key for authentication | Yes |
| `proxmox_node` | Target Proxmox node | Yes |
| `vm_nameservers` | DNS servers | No |

## Development

### Running Pre-commit Hooks

```bash
# Run all hooks on all files
pre-commit run -a

# Run specific hook
pre-commit run tofu_fmt
```

### Formatting Code

OpenTofu files are automatically formatted by pre-commit hooks, but you can also format manually:

```bash
tofu fmt -recursive .
```

## Troubleshooting

### Common Issues

**Issue: Terragrunt fails with authentication error**
- Verify your Proxmox credentials in `common.hcl`
- Ensure the `terraform-prov@pve` user has proper permissions

**Issue: VM fails to start with cloud-init**
- Verify the cloud-init template exists and is properly configured
- Check that the QEMU guest agent snippet is accessible at `/var/lib/vz/snippets/qemu-guest-agent.yml`

**Issue: Pre-commit hooks not running**
- Ensure pre-commit is installed: `pre-commit --version`
- Reinstall hooks: `pre-commit install`

**Issue: IP address conflicts**
- Ensure each service has a unique `vm_id` and `vm_ip_address`
- Check your network for IP address availability 