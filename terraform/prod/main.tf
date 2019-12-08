terraform {
  required_version = "0.12.8"
}

provider "google" {
  version = "2.15"
  project = var.project
  region  = var.region
}

module "app" {
  source           = "../modules/app"
  tags             = var.tags
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  zone             = var.zone
  app_disk_image   = var.app_disk_image
  ssh_users        = var.ssh_users
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
  ssh_users       = var.ssh_users
}


module "vpc" {
  source = "../modules/vpc"
  source_ranges = ["82.202.237.245/32"]
}