variable "host_os" {
  type = string

  default = "Darwin"
}

variable "host_arch" {
  type = string

  default = "arm64"
}

variable "accelerator" {
  type = string

  default = null
}

variable "headless" {
  type = bool

  default = false
}

variable "efi_firmware_code" {
  type = string

  default = null
}

variable "efi_firmware_vars" {
  type = string

  default = null
}

variable "disk_size" {
  type = string

  default = "40G"
}

variable "memory" {
  type = string

  default = "8192"
}

variable "cpus" {
  type = string

  default = "8"
}