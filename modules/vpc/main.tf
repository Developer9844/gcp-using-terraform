resource "google_compute_network" "myVPC" {
  name                    = var.project_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "subnet-us-central1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.myVPC.id
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "subnet-us-east1"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-east1"
  network       = google_compute_network.myVPC.id
}

resource "google_compute_router" "myVPC_Router" {
  name    = "${var.project_name}-router"
  region  = "us-east1"
  network = google_compute_network.myVPC.id
}

resource "google_compute_router_nat" "nat_router" {
  name                               = "${var.project_name}-nat-route"
  router                             = google_compute_router.myVPC_Router.name
  region                             = "us-east1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}


resource "google_compute_firewall" "myVPC_Firewall" {
  name    = "${var.project_name}-firewall"
  network = google_compute_network.myVPC.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags = ["bastion"]
  source_ranges = ["103.215.158.90/32"]
  direction     = "INGRESS"
}


resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.myVPC.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["auto-scaling-group"]
  direction   = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.myVPC.id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["auto-scaling-group"]
  direction   = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}