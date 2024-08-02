locals {
  efi_firmware_paths_os_map = {
    Darwin = {
      arm64 = {
        code = "/opt/homebrew/opt/qemu/share/qemu/edk2-aarch64-code.fd"
        vars = "/opt/homebrew/opt/qemu/share/qemu/edk2-arm-vars.fd"
      }
    }
  }

  efi_firmware_paths = {
    code = var.efi_firmware_code == null ? local.efi_firmware_paths_os_map[var.host_os][var.host_arch].code : var.efi_firmware_code
    vars = var.efi_firmware_vars == null ? local.efi_firmware_paths_os_map[var.host_os][var.host_arch].vars : var.efi_firmware_vars
  }

  accelerator_os_map = {
    Darwin = "hvf"
  }

  displays = {
    Darwin = "cocoa,show-cursor=on"
  }

  accelerator = var.accelerator == null ? local.accelerator_os_map[var.host_os] : var.accelerator

  qemu_binary = {
    arm64 = "qemu-system-aarch64"
  }
}

locals {
  ssh_private_key_file = "${path.root}/scripts/keys/packer"
  ssh_public_key       = file("${path.root}/scripts/keys/packer.pub")
}