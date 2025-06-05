output "instance_group_manager" {
  value = google_compute_region_instance_group_manager.sample_instance_group_manager.instance_group
}
output "health_check" {
  value = google_compute_health_check.instance_health_check.id
}