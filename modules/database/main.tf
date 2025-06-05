

resource "google_sql_database_instance" "my_database" {
  name             = "${var.project_name}-instance-database"
  database_version = "MYSQL_8_0" # version 8.0
  region           = var.gcp_private_region
  settings {
    tier              = "db-n1-standard-1"
    availability_type = "REGIONAL" # ZONAL or REGIONAL
    disk_size         = 20
    disk_type         = "PD_SSD"
    disk_autoresize   = false

    # Backup Configuration
    backup_configuration {
      enabled                        = true
      start_time                     = "02:00" # UTC time backup start
      location                       = ""
      point_in_time_recovery_enabled = false
      binary_log_enabled             = true
    }


    # Maintenance window config
    maintenance_window {
      day          = 7        # 1=Monday, 7=Sunday
      hour         = 1        # 0-23 UTC
      update_track = "stable" # Can be "stable" or "canary"
    }

    # IP configuration
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_self_link
    }

  }
  deletion_protection = false
  depends_on = [
    var.private_networking_connection
  ]

}

# 2. User
resource "google_sql_user" "default" {
  name        = "root"
  instance    = google_sql_database_instance.my_database.name
  password_wo = var.mysql_root_password
}
