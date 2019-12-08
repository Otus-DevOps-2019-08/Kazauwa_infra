variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}
variable service_port {
  description = "App port to listen to"
  default     = 80
}
variable tags {
  description = "Tags for firewall rules"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the public key used for ssh access"
}
variable ssh_users {
  description = "List of users for ssh connection"
}
variable target_count {
  description = "Number of created instances"
  default     = 1
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

