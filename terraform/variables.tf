variable project {
  description = "Project ID"
}

variable region {
  description = "Region"

  # Значение по умолчанию
  default = "europe-west3"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable zone {
  description = "Zone"
  default     = "*"
}

variable public_key_path_appuser1 {
  description = "Path to the public key used for ssh access appuser1"
}

variable public_key_path_appuser2 {
  description = "Path to the public key used for ssh access appuser2"
}

variable public_key_path_appuser3 {
  description = "Path to the public key used for ssh access appuser3"
}
variable count {
  description = "count instances"
  default     = "1"
}
