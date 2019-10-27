output "app_external_ip" {
  value = google_compute_instance.app[*].network_interface.0.access_config.0.nat_ip
}

output "app_lb_ip" {
  value = google_compute_forwarding_rule.reddit-app-lb-forwarding.ip_address
}