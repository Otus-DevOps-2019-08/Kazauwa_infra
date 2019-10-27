resource "google_compute_forwarding_rule" "reddit-app-lb-forwarding" {
  project               = var.project
  name                  = "lb-reddit-app"
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.service_port
  region                = var.region
}

resource "google_compute_target_pool" "default" {
  project   = var.project
  name      = "reddit-app-target-pool"
  region    = var.region
  instances = google_compute_instance.app[*].self_link

  health_checks = [
    google_compute_http_health_check.default.name,
  ]
}

resource "google_compute_http_health_check" "default" {
  project      = var.project
  name         = "reddit-app-hc"
  request_path = "/"
  port         = var.service_port
}

resource "google_compute_firewall" "default-lb-fw" {
  project = var.project
  name    = "reddit-app-vm-service"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.service_port]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.tags
}
