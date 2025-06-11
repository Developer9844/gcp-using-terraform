resource "google_container_cluster" "gke_cluster" {
  name     = "${var.project_name}-gke-cluster"
  location = "us-east1-b" # zonal base, you can also make region base

  network    = var.vpc_self_link
  subnetwork = var.private_subnet_name

  remove_default_node_pool = true
  initial_node_count       = 1

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 2
      maximum       = 50
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 4
      maximum       = 50
    }


    auto_provisioning_defaults {
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
    auto_provisioning_locations = [
      "us-east1-b",
      "us-east1-c"
    ]
    autoscaling_profile = "OPTIMIZE_UTILIZATION"   # BALANCED || we use to agressively down the nodes by optimization

  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false           # true = only internal access
    master_ipv4_cidr_block  = "172.16.0.0/28" # required
  }

  release_channel {
    channel = "REGULAR"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Public"
    }
  }

  enable_shielded_nodes = true
}


# GKE Node Pool - primary - recommended

resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  cluster  = google_container_cluster.gke_cluster.name
  location = "us-east1-b"

  #   node_count = 2
  autoscaling {
    min_node_count = 2
    max_node_count = 20
  }
  node_config {
    machine_type = "e2-standard-4"
    disk_size_gb = 30
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = "prod"
    }
    tags = ["gke-node-general"]

  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}


# High availability Kafka node pool - beefier machines, smaller autoscale range
# resource "google_container_node_pool" "kafka_nodes" {
#   name       = "kafka-node-pool"
#   cluster    = google_container_cluster.gke_cluster.name
#   location   = "us-east1-b"

#   autoscaling {
#     min_node_count = 3    # HA - keep minimum 3 nodes
#     max_node_count = 5
#   }

#   node_config {
#     machine_type = "n2-standard-8"  # more CPU/RAM for Kafka
#     disk_size_gb = 100              # larger disk
#     disk_type    = "pd-ssd"         # SSD preferred for DB workloads
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#     labels = {
#       env  = "prod"
#       role = "kafka"
#     }
#     tags = ["kafka-node"]
#     # optional: taints to isolate kafka pods
#     taint {
#       key    = "role"
#       value  = "kafka"
#       effect = "NO_SCHEDULE"
#     }
#   }
# }

# # Frontend node pool - smaller machine, smaller autoscale
# resource "google_container_node_pool" "frontend_nodes" {
#   name       = "frontend-node-pool"
#   cluster    = google_container_cluster.gke_cluster.name
#   location   = "us-east1-b"

#   autoscaling {
#     min_node_count = 1
#     max_node_count = 3
#   }

#   node_config {
#     machine_type = "e2-small"  # smaller for frontend
#     disk_size_gb = 30
#     disk_type    = "pd-standard"
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#     labels = {
#       env  = "prod"
#       role = "frontend"
#     }
#     tags = ["frontend-node"]
#   }
# }
