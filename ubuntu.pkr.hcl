locals {
  ubuntu_iso          = var.ubuntu_iso_url == null ? "https://cdimage.ubuntu.com/releases/${var.ubuntu_version}/release/ubuntu-${var.ubuntu_version}-live-server-${var.ubuntu_arch}.iso" : var.ubuntu_iso_url
  ubuntu_iso_checksum = var.ubuntu_iso_checksum == null ? "file:https://cdimage.ubuntu.com/releases/${var.ubuntu_version}/release/SHA256SUMS" : var.ubuntu_iso_checksum

  ubuntu_name             = "ubuntu-${var.ubuntu_version}-${var.ubuntu_arch}"
  ubuntu_output_directory = "builds/${local.ubuntu_name}"
}

source "qemu" "ubuntu" {

  qemu_binary = local.qemu_binary[var.host_arch]

  vm_name = local.ubuntu_name

  iso_url      = local.ubuntu_iso
  iso_checksum = local.ubuntu_iso_checksum

  accelerator  = local.accelerator
  machine_type = "virt"

  disk_size = var.ubuntu_disk_size
  format    = "qcow2"

  efi_firmware_code = local.efi_firmware_paths.code
  efi_firmware_vars = local.efi_firmware_paths.vars

  headless            = var.headless
  use_default_display = true
  display             = local.displays[var.host_os]

  memory = var.ubuntu_memory

  cpu_model = "host"
  cpus      = var.ubuntu_cpus

  qemuargs = var.headless ? [] : [
    ["-device", "virtio-gpu-pci"],
    ["-device", "usb-ehci"],
    ["-device", "usb-kbd"],
    ["-device", "usb-mouse"],
  ]

  shutdown_command = "echo '${local.password}' | sudo -S shutdown -P now"

  ssh_username         = local.username
  ssh_password         = local.password
  ssh_private_key_file = local.ssh_private_key_file
  ssh_timeout          = "30m"

  boot_wait = "10s"
  boot_command = [
    "e<wait><down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{.HTTPIP}}:{{.HTTPPort}}/",
    "<f10>"
  ]

  http_content = {
    "/meta-data" = file("${path.root}/http/meta-data")
    "/user-data" = templatefile("${path.root}/http/user-data.pkrtpl.hcl", {
      hostname           = local.hostname
      username           = local.username
      encrypted_password = local.encrypted_password
      ssh_public_key     = local.ssh_public_key
    })
  }

  output_directory = "builds/${local.ubuntu_name}"
}

build {
  name = "qemu"
  sources = [
    "source.qemu.ubuntu"
  ]

  post-processor "shell-local" {
    inline = ["mv ${local.ubuntu_output_directory}/${local.ubuntu_name} ${local.ubuntu_output_directory}/${local.ubuntu_name}.qcow2"]
  }
}

