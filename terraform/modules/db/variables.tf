variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "*"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-mongodb"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}
