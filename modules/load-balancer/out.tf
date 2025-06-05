output "forwarding_ip" {
  value = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}