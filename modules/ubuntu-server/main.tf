# Shared module forterr creating Ubuntu Server VMs on Proxmox

resource "proxmox_vm_qemu" "ubuntu_server" {
  name        = var.vm_name
  target_node = var.proxmox_node
  vmid        = var.vm_id

  boot   = "order=scsi0"
  clone  = var.vm_template
  scsihw = "virtio-scsi-single"

  cpu {
    cores   = var.vm_cores
    sockets = 1

  }
  memory = var.vm_memory

  agent = 1

  onboot  = true
  startup = "order=1"

  vm_state         = "running"
  automatic_reboot = true

  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.vm_disk_size
          storage = "local-lvm"
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud Init Configuration
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = var.vm_nameservers
  ipconfig0  = "ip=${var.vm_ip_address},gw=${var.vm_gateway},ip6=dhcp"
  skip_ipv6  = true
  ciuser     = var.vm_user
  sshkeys    = var.ssh_public_key

  serial {
    id = 0
  }
  #os_type   = "cloud-init"



  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}