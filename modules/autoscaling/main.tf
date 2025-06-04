resource "google_compute_instance_template" "instance_template" {
  name           = "${var.project_name}-instance-template"
  machine_type   = "e2-micro"
  can_ip_forward = false
  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
    mode         = "READ_WRITE"
    type         = "PERSISTENT"
  }
  network_interface {
    network    = var.vpc_name
    subnetwork = var.public_subnet_name
    access_config {}
  }

  metadata = {
    Name = "${var.project_name}-instance-template"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install apache2 -y

  EOF

  tags = ["auto-scaling-group"]

}

resource "google_compute_health_check" "instance_health_check" {
  name                = "${var.project_name}-health-check"
  check_interval_sec  = 10
  timeout_sec         = 10
  healthy_threshold   = 5
  unhealthy_threshold = 10
  http_health_check {
    request_path = "/health.jsp"
    port         = 8080
  }

}


resource "google_compute_region_instance_group_manager" "sample_instance_group_manager" {
  name = "instance-group-manager"
  version {
    instance_template = google_compute_instance_template.instance_template.name
  }
  region             = "us-east1"
  base_instance_name = "instance-group-manager"
}


resource "google_compute_region_autoscaler" "autoscaling" {
  name   = "${var.project_name}-autoscaling"
  region = "us-east1"
  target = google_compute_region_instance_group_manager.sample_instance_group_manager.name
  autoscaling_policy {
    min_replicas    = 1
    max_replicas    = 2
    cooldown_period = 60
    cpu_utilization {
      target = "0.8"
    }
  }
}
