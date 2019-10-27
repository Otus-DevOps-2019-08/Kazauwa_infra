terraform {
  required_version = "0.12.12"
}

provider "google" {
  version = "2.15"

  project = var.project
  region  = var.region
}

resource "google_compute_instance" "app" {
  name         = "reddit-app-${count.index}"
  machine_type = "f1-micro"
  zone         = var.zone
  tags         = var.tags
  count        = var.target_count
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = join("\n", [for user in var.ssh_users : "${user}:${file(var.public_key_path)}"])
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = [var.service_port]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.tags
}
