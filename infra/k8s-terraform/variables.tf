variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used by provisioners"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "key.json"
}
variable count_instance {
  # кол-во создаваемых инстансов
  default = "2"
}
variable network_id {
  description = "Network id"
}
variable service_account_id {
  description = "Service account ID"
}
variable cores {
  description = "nodes cores"
  default     = 4
}
variable memory {
  description = "nodes memories"
  default     = 8
}
variable size {
  description = "nodes sizes"
  default     = 64
}
