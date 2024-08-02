variable "nixos_iso_url" {
  type = string

  default = null
}

variable "nixos_iso_checksum" {
  type = string

  default = null
}

variable "nixos_version" {
  type = string

  default = "24.05"
}

variable "nixos_disk_size" {
  type = string

  default = null
}

variable "nixos_memory" {
  type = string

  default = null
}

variable "nixos_cpus" {
  type = string

  default = null
}