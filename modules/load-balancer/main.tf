# 1. Need to create health check for load balancer
# we have health check in  already created in autoscaling module
# resource "google_compute_health_check" "health_check" {
#   name = "${var.project_name}-health-check"
#   http_health_check {
#     port         = 80
#     request_path = "/"
#   }
# }

# 2. Need to create backend service
resource "google_compute_backend_service" "backend_service" {
  name                  = "${var.project_name}-backend-service"
  port_name             = "http"  # must match with port name of manage instance group
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [var.health_check]
  backend {
    group = var.instance_group_manager
  }

  enable_cdn = false
}

# 3. Need to create URL map

resource "google_compute_url_map" "url_map" {
  name            = "${var.project_name}-url-map"
  default_service = google_compute_backend_service.backend_service.id
}

# 4. Target(http proxy)

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.project_name}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

# 5. Global forwarding rule

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name                  = "${var.project_name}-global-forward-rule"
  target                = google_compute_target_http_proxy.http_proxy.id
  port_range            = 80
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
}
