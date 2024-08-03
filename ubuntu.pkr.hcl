locals {
  ubuntu_iso          = var.ubuntu_iso_url == null ? "https://cdimage.ubuntu.com/releases/${var.ubuntu_version}/release/ubuntu-${var.ubuntu_version}-live-server-${var.host_arch}.iso" : var.ubuntu_iso_url
  ubuntu_iso_checksum = var.ubuntu_iso_checksum == null ? "file:https://cdimage.ubuntu.com/releases/${var.ubuntu_version}/release/SHA256SUMS" : var.ubuntu_iso_checksum

  ubuntu_name             = "ubuntu-${var.ubuntu_version}-${var.host_arch}"
  ubuntu_output_directory = "builds/${local.ubuntu_name}"

  ubuntu_disk_size = var.ubuntu_disk_size == null ? var.disk_size : var.ubuntu_disk_size
  ubuntu_memory    = var.ubuntu_memory == null ? var.memory : var.ubuntu_memory
  ubuntu_cpus      = var.ubuntu_cpus == null ? var.cpus : var.ubuntu_cpus

  ubuntu_hostname = "box"
  ubuntu_username = "packer"

  ubuntu_password           = "packer"
  ubuntu_encrypted_password = "$1$0WOmzOLg$.n19Ld4vk.QhKK8isMCLY/" # openssl passwd
}

source "qemu" "ubuntu" {

  qemu_binary = local.qemu_binary[var.host_arch]

  vm_name = local.ubuntu_name

  iso_url      = local.ubuntu_iso
  iso_checksum = local.ubuntu_iso_checksum

  accelerator  = local.accelerator
  machine_type = local.machine_type

  disk_size = local.ubuntu_disk_size
  format    = "qcow2"

  efi_firmware_code = local.efi_firmware_paths.code
  efi_firmware_vars = local.efi_firmware_paths.vars

  headless            = var.headless
  use_default_display = true
  display             = local.displays[var.host_os]

  memory = local.ubuntu_memory

  cpu_model = "host"
  cpus      = local.ubuntu_cpus

  qemuargs = var.headless ? [] : [
    ["-device", "virtio-gpu-pci"],
    ["-device", "usb-ehci"],
    ["-device", "usb-kbd"],
    ["-device", "usb-mouse"],
  ]

  shutdown_command = "echo '${local.ubuntu_password}' | sudo -S shutdown -P now"

  ssh_username         = local.ubuntu_username
  ssh_private_key_file = local.ssh_private_key_file
  ssh_timeout          = "30m"

  boot_wait = "10s"
  boot_command = [
    "e<wait><down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{.HTTPIP}}:{{.HTTPPort}}/",
    "<f10>"
  ]

  http_content = {
    "/meta-data" = file("${path.root}/scripts/ubuntu/meta-data")
    "/user-data" = templatefile("${path.root}/scripts/ubuntu/user-data.pkrtpl.hcl", {
      hostname           = local.ubuntu_hostname
      username           = local.ubuntu_username
      encrypted_password = local.ubuntu_encrypted_password
      ssh_public_key     = local.ssh_public_key
    })
  }

  output_directory = "builds/${local.ubuntu_name}"
}

build {
  name = "ubuntu"
  sources = [
    "source.qemu.ubuntu"
  ]

  post-processor "shell-local" {
    inline = ["mv ${local.ubuntu_output_directory}/${local.ubuntu_name} ${local.ubuntu_output_directory}/${local.ubuntu_name}.qcow2"]
  }
}

