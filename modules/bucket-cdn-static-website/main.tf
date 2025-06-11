resource "google_storage_bucket" "storage_bucket" {
  name                        = "${var.project_name}-storage-bucket"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}


resource "google_storage_bucket_iam_member" "lb_access" {
  bucket = google_storage_bucket.storage_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}


resource "google_compute_backend_bucket" "cdn_backend" {
  name        = "static-cdn"
  bucket_name = google_storage_bucket.storage_bucket.name
  enable_cdn  = true
}


resource "google_compute_url_map" "backend_url_map" {
  name            = "cdn-url-map"
  default_service = google_compute_backend_bucket.cdn_backend.id
}



resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  name = "cdn-ssl-cert"
  managed {
    domains = ["cdn.sparkforge.xyz"]
  }
}


# Target HTTPS Proxy

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "https-proxy"
  url_map          = google_compute_url_map.backend_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_cert.id]
}



resource "google_compute_global_address" "lb_ip" {
  name = "cdn-lb-ip"
}

output "global_ip" {
  value = google_compute_global_address.lb_ip.address
}

resource "google_compute_global_forwarding_rule" "https_forward" {
  name                  = "https-forward"
  target                = google_compute_target_https_proxy.https_proxy.id
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.lb_ip.address
}

# To clear the cache
# gcloud compute url-maps invalidate-cdn-cache cdn-url-map   --path "/*" --global 