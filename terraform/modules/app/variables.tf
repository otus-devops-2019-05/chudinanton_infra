variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "*"
}

variable count {
  description = "count instances"
  default     = "1"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "mongodb_ip" {
  description = "MongoDB IP"
}
