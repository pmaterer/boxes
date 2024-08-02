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

variable "ubuntu_iso_url" {
  type = string

  default = null
}

variable "ubuntu_iso_checksum" {
  type = string

  default = null
}

variable "ubuntu_version" {
  type = string

  default = "24.04"
}


variable "ubuntu_arch" {
  type = string

  default = "arm64"
}

variable "ubuntu_disk_size" {
  type = string

  default = "20G"
}

variable "ubuntu_memory" {
  type = string

  default = "8192"
}

variable "ubuntu_cpus" {
  type = string

  default = "8"
}