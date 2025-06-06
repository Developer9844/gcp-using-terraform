resource "google_vpc_access_connector" "vpc_connector" {
  name          = "${var.project_name}-cloud-run-connector"
  region        = var.gcp_region_central
  network       = var.vpc_name
  ip_cidr_range = "10.0.1.0/24"
}


resource "google_cloud_run_service" "cloud_run_container" {
  name     = "${var.project_name}-container"
  location = var.gcp_region_central
  template {
    # metadata {
    #   annotations = {
    #     "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_connector.name
    #     "run.googleapis.com/vpc-access-egress"    = "all"
    #   }
    # }
    spec {
      containers {
        image = "gcr.io/aqueous-thought-461705-k1/auth-app:frontend-v1"
        resources {
          limits = {
            memory = "256Mi"
          }
        }
        ports {
          name           = "http1" # must be one of empty, 'http1' or 'h2c'
          container_port = 3000
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true

  }
}

# Allow public unauthenticated access
resource "google_cloud_run_service_iam_member" "iam_member" {
  service  = google_cloud_run_service.cloud_run_container.name
  location = google_cloud_run_service.cloud_run_container.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
