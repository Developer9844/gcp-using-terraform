resource "google_project_iam_member" "iam_user" {
  project = var.project_id
  member  = "user:${var.user_account}"
  role    = "roles/viewer"
}


resource "google_project_iam_member" "iam_user_vm" {
  project = var.project_id
  member  = "user:${var.user_account}"
  role    = "roles/compute.admin"
}

resource "google_project_iam_member" "iam_user_storage" {
  project = var.project_id
  member  = "user:${var.user_account}"
  role    = "roles/storage.admin"
}


resource "google_compute_subnetwork_iam_member" "developer_network_access" {
  project    = "aqueous-thought-461705-k1"
  region     = "us-east1"
  subnetwork = "default"
  role       = "roles/compute.networkUser"
  member     = "user:ankush.katkurwar30@gmail.com"
}

resource "google_service_account_iam_binding" "name" {
  service_account_id = "projects/aqueous-thought-461705-k1/serviceAccounts/825122014401-compute@developer.gserviceaccount.com"
  members            = ["user:${var.user_account}"]
  role               = "roles/iam.serviceAccountUser"
}

# Define a Custom Role
# resource "google_project_iam_custom_role" "developer" {
#   role_id     = "developerCustomRole"
#   title       = "Developer Custom Role"
#   description = "Full access to Compute and Storage"
#   project     = var.project_id

#   permissions = [
#     "compute.instances.create",
#     "compute.instances.delete",
#     "compute.instances.get",
#     "compute.instances.list",
#     "compute.instances.start",
#     "compute.instances.stop",
#     "compute.subnetworks.use",
#     "compute.instances.setMetadata",
#     "compute.disks.create",
#     "compute.disks.delete",
#     "compute.disks.get",
#     "compute.disks.list",
#     "storage.buckets.create",
#     "storage.buckets.delete",
#     "storage.buckets.get",
#     "storage.buckets.list",
#     "storage.objects.create",
#     "storage.objects.delete",
#     "storage.objects.get",
#     "storage.objects.list"
#   ]
# }

# # bind the custom role
# resource "google_project_iam_member" "developer_bind" {
#   project = var.project_id
#   member  = "user:${var.user_accout}"
#   role    = google_project_iam_custom_role.developer.name
# }




