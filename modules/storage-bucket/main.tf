resource "google_storage_bucket" "myFirstBucket" {
  name     = var.project_name
  location = "US"
}
