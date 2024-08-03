locals {

  nixos_iso_arch = {
    arm64 = "aarch64"
    x86_64 = "x86_64"
  }

  nixos_iso          = var.nixos_iso_url == null ? "https://channels.nixos.org/nixos-${var.nixos_version}/latest-nixos-minimal-${local.nixos_iso_arch[var.host_arch]}-linux.iso" : var.nixos_iso_url
  nixos_iso_checksum = var.nixos_iso_checksum == null ? "file:https://channels.nixos.org/nixos-${var.nixos_version}/latest-nixos-minimal-${local.nixos_iso_arch[var.host_arch]}-linux.iso.sha256" : var.nixos_iso_checksum

  nixos_name             = "nixos-${var.nixos_version}-${var.host_arch}"
  nixos_output_directory = "builds/${local.nixos_name}"

  nixos_disk_size = var.nixos_disk_size == null ? var.disk_size : var.nixos_disk_size
  nixos_memory    = var.nixos_memory == null ? var.memory : var.nixos_memory
  nixos_cpus      = var.nixos_cpus == null ? var.cpus : var.nixos_cpus

  nixos_username = "nixos"
}

source "qemu" "nixos" {

  qemu_binary = local.qemu_binary[var.host_arch]

  vm_name = local.nixos_name

  iso_url      = local.nixos_iso
  iso_checksum = local.nixos_iso_checksum

  accelerator  = local.accelerator
  machine_type = local.machine_type

  disk_size = local.nixos_disk_size
  format    = "qcow2"

  efi_firmware_code = local.efi_firmware_paths.code
  efi_firmware_vars = local.efi_firmware_paths.vars

  headless            = var.headless
  use_default_display = true
  display             = local.displays[var.host_os]

  memory = local.nixos_memory

  cpu_model = "host"
  cpus      = local.nixos_cpus

  qemuargs = var.headless ? [] : [
    ["-device", "virtio-gpu-pci"],
    ["-device", "usb-ehci"],
    ["-device", "usb-kbd"],
    ["-device", "usb-mouse"],
  ]

  shutdown_command = "sudo -S shutdown -P now"

  ssh_username         = local.nixos_username
  ssh_private_key_file = local.ssh_private_key_file
  ssh_timeout          = "10m"

  boot_wait = "40s"
  boot_command = [
    "mkdir -m 0700 .ssh<enter>",
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/keys/packer.pub > .ssh/authorized_keys<enter>",
    "sudo systemctl start sshd<enter>"
  ]

  http_directory = "${path.root}/scripts"

  output_directory = "builds/${local.nixos_name}"
}

build {
  name = "nixos"

  sources = [
    "source.qemu.nixos"
  ]

  provisioner "shell" {
    execute_command = "sudo su -c '{{ .Vars }} {{ .Path}}'"
    script          = "${path.root}/scripts/nixos/setup.sh"
  }

  post-processor "shell-local" {
    inline = ["mv ${local.nixos_output_directory}/${local.nixos_name} ${local.nixos_output_directory}/${local.nixos_name}.qcow2"]
  }
}

