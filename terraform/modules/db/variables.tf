variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
variable ssh_users {
  description = "List of users for ssh connection"
}