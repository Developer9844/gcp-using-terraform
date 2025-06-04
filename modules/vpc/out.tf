output "vpc_id" {
  value = google_compute_network.myVPC.id
}
output "vpc_name" {
  value = google_compute_network.myVPC.name
}

output "private_subnet_name" {
  value = google_compute_subnetwork.private_subnet.name
}

output "public_subnet_name" {
  value = google_compute_subnetwork.public_subnet.name
}