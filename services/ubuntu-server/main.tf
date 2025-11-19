# This file contains shared infrastructure that services depend on 

resource "proxmox_vm_qemu" "ubuntu_server" {
  name        = var.vm_name
  target_node = var.proxmox_node
  vmid        = var.vm_id

  clone = var.vm_template

  cpu {
    cores   = var.vm_cores
    sockets = 1

  }
  memory = var.vm_memory

  agent = 1

  onboot  = true
  startup = "order=1"

  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.vm_disk_size
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

  os_type   = "cloud-init"
  ipconfig0 = "ip=${var.vm_ip_address},gw=${var.vm_gateway}"

  nameserver = var.vm_nameservers

  ciuser  = var.vm_user
  sshkeys = var.ssh_public_key

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}