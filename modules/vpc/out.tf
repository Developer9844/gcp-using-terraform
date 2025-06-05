output "vpc_id" {
  value = google_compute_network.myVPC.id
}
output "vpc_name" {
  value = google_compute_network.myVPC.name
}
output "vpc_self_link" {
  value = google_compute_network.myVPC.self_link
}

output "private_subnet_name" {
  value = google_compute_subnetwork.private_subnet.name
}

output "private_subnet_id" {
  value = google_compute_subnetwork.private_subnet.id
}

output "public_subnet_name" {
  value = google_compute_subnetwork.public_subnet.name
}

output "public_subnet_id" {
  value = google_compute_subnetwork.public_subnet.id
}

# output "private_networking_connection" {
#   value = google_service_networking_connection.private_vpc_connection.id
# }