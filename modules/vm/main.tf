resource "google_compute_instance" "my_instance" {
  name         = "${var.project_name}-private"
  machine_type = "e2-micro"
  zone         = "us-east1-b"
  network_interface {
    subnetwork         = var.private_subnet_name
    subnetwork_project = var.project_id
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }

  }
  tags = ["private"]

  metadata = {
    ssh-keys = "ankush-katkurwar:${file("/home/ankush-katkurwar/.ssh/id_rsa.pub")}"
  }
}



# If we need static ip
# resource "google_compute_address" "static_ip" {
#   name   = "static-elastic-ip"
#   region = "us-central1"
# }



resource "google_compute_instance" "bastion_instance" {
  name         = "${var.project_name}-public"
  machine_type = "e2-micro"
  zone         = "us-central1-c"
  network_interface {
    subnetwork         = var.public_subnet_name
    subnetwork_project = var.project_id
     # 🔑 This assigns an ephemeral external IP (auto-assigned)
    
    access_config {}
    # This is attach the static ip
    # access_config {
    #   nat_ip = google_compute_address.static_ip.address
    # }
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }

  }
  
  tags = ["bastion"]

  metadata = {
    ssh-keys = "ankush-katkurwar:${file("/home/ankush-katkurwar/.ssh/id_rsa.pub")}"
  }
}
