/* resource "google_compute_region_backend_service" "instance-group-backendservice" {
  name             = "regional-backend-service"
  description      = "Region Instance Group Backend Service"
#  protocol         = "TCP"
  region           = var.region
#  protocol         = "HTTP"
  protocol         = "HTTP"
  port_name        = var.named_port_name
  load_balancing_scheme = "INTERNAL_MANAGED"
  locality_lb_policy = "ROUND_ROBIN"
  # health_checks = [google_compute_region_health_check.http-healthcheck.self_link]
  health_checks   = [google_compute_region_health_check.http-healthcheck.id]
  timeout_sec      = 10
  session_affinity = "NONE"

  backend {
#    group = "${google_compute_region_instance_group_manager.instance_group_manager.instance_group}"
  #   group = var.instance_group_self_link
     group          = var.instance_group
   #  group  = var.instance_group_name
     balancing_mode = "UTILIZATION"
    # capacity_scaler = 1.0
     capacity_scaler = 0.8
  }
  */
resource "google_compute_backend_service" "instance-group-backendservice" {
  name             = "regional-backend-service"
  description      = "Region Instance Group Backend Service"
#  protocol         = "TCP"
#  region           = var.region
#  protocol         = "HTTP"
  protocol         = "HTTP"
 port_name        = var.named_port_name
#   port_name       = var.http_check_port_name
 # load_balancing_scheme = "INTERNAL_MANAGED"
 # locality_lb_policy = "ROUND_ROBIN"
  # health_checks = [google_compute_region_health_check.http-healthcheck.self_link]
  health_checks   = [google_compute_health_check.http-healthcheck.id]
#  timeout_sec      = 10
 #Change value to get more time to instance group autoscaler to complete its job
   timeout_sec      = 60
  session_affinity = "NONE"
  #load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  backend {
#    group = "${google_compute_region_instance_group_manager.instance_group_manager.instance_group}"
  #   group = var.instance_group_self_link
     group          = var.instance_group
    #  group = var.instance_group_id
   #  group  = var.instance_group_name
     balancing_mode = "UTILIZATION"
    # capacity_scaler = 1.0
     capacity_scaler = 0.8
  }
 /*  log_config {
    enable = true
  } */
 depends_on = [google_compute_health_check.http-healthcheck]
#   health_checks = ["${google_compute_health_check.http_hc.self_link}"]
#  health_checks = [var.healthcheck_self_link]
#    health_checks = [google_compute_region_health_check.http-healthcheck.self_link]
}


/* resource "google_compute_region_url_map" "LB-region-url-map" {
#  provider = google-beta

  region          = var.region
  project         = var.project
  name            = "bookshelf-http-lb"
  default_service = google_compute_region_backend_service.instance-group-backendservice.id
  /*  path_matcher {
    name            = "default-path"
#  default_service = google_compute_region_backend_service.default.id
  default_service = google_compute_region_backend_service.instance-group-backendservice.id
   } */
#}

# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "LB-url-map" {
  project         = var.project
#  count           = var.create_url_map ? 1 : 0
  name            = "${var.lb_name}-lb"
 default_service = google_compute_backend_service.instance-group-backendservice.self_link
/*    host_rule {
    hosts        = ["*"]
    path_matcher = "pythonapp"
  }
   path_matcher {
    name            = "pythonapp"
     default_service = google_compute_backend_service.instance-group-backendservice.self_link
   
    path_rule {
      paths   = ["/"]
      service = google_compute_backend_service.instance-group-backendservice.self_link
    }
    } */
 /*   default_url_redirect {
    https_redirect = true
    strip_query    = false
  } */

}


/* resource "google_compute_region_target_http_proxy" "region-target-http-prxy" {
#  provider = google-beta

  region  = var.region
  name    = "booshelf-http-proxy"
  depends_on  = [google_compute_region_url_map.LB-region-url-map]
#  url_map = google_compute_region_url_map.default.id
#  url_map = var.url-map-id
  url_map = google_compute_region_url_map.LB-region-url-map.id
} */

# HTTP proxy when http forwarding is true
resource "google_compute_target_http_proxy" "target-http-prxy" {
  project = var.project
#  count   = var.http_forward ? 1 : 0
  name    = "${var.lb_name}-proxy"
  url_map = google_compute_url_map.LB-url-map.self_link
  
}

resource "google_compute_global_forwarding_rule" "fw-rule-for-lb" {
  project    = var.project
 # count      = var.http_forward ? 1 : 0
  name       = "${var.lb_name}-fw-rule"
  target     = google_compute_target_http_proxy.target-http-prxy.self_link
 # target     = google_compute_target_http_proxy.target-http-prxy[0].self_link
#  ip_address = local.address
  port_range = "8080"
}
# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "http-healthcheck" {
  name = "${var.lb_name}-healthcheck"
  timeout_sec = 5
 #timeout_sec = 1
 
 # check_interval_sec = 10

 check_interval_sec = 10
 #  check_interval_sec = 1
    healthy_threshold   = 2
  unhealthy_threshold = 3
   
/*    http_health_check {
  #  port_name = var.named_port_name 
   # port_name = var.http_check_port_name
    port = 8080
    request_path       = "/"
  } */
         tcp_health_check {
     port = "8080"
     port_name = "tcp-hc"
   #  port_name = var.named_port_name
  #  request = "/"
  }  
 
}
   /* resource "google_compute_health_check" "http-healthcheck" {
  name        = "bookshelf-app-healthcheck"
  description = "Http healthcheck on port 8080"

  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3
  
#Test data
   check_interval_sec  = 4
  timeout_sec         = 4
  healthy_threshold   = 2
  unhealthy_threshold = 4 */
##########################
/*    http_health_check {
    request_path = "/"
    port = 8080
  }
}  */ 
/*  resource "google_compute_region_health_check" "http-healthcheck" {
#  depends_on = [google_compute_firewall.fw4]
#  depends_on  = [var.proxy-subnet-http-allow-rule]
  provider = google-beta
  region = var.region
  project = var.project
  name   = "bookshelf-app-healthcheck"
  description = "Http healthcheck on port 8080"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3
 /*     tcp_health_check {
     port = "8080"
     port_name = var.named_port_name
  #  request = "/"
  } */
#     http_health_check {
  #  port_name          = var.named_port_name
    #port_specification = "USE_NAMED_PORT"
#    port               = 8080
#    request_path       = "/"

#  } 




/*    http_health_check {
    port_specification = "USE_FIXED_PORT"
    port               = 8080
    request_path       = "/"

  }   */

/*   resource "google_compute_health_check" "http-health-check" {
  name        = "bookshelf-app-healthcheck"
  description = "Health check via http"
  depends_on  = [var.proxy-subnet-http-allow-rule]
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3

    tcp_health_check {
    port = "8080"
  #  request = "/"
  }  */
/* http_health_check {
  #port_specification possible values - USE_FIXED_PORT, USE_NAMED_PORT,USE_SERVING_PORT
    # port_specification = "USE_FIXED_PORT"
  port_specification = "USE_FIXED_PORT"
  #port_name          = "healthcheck-port-checking"
  #  port_specification  = ""
    port               = 8080
    request_path       = "/books"

  }   */ 
/*  http_health_check {
  #   port_specification = "USE_SERVING_PORT"
  
  #  port_specification  = ""
    port               = 8080
    request_path       = "/"

  }  */


// Forwarding rule for Internal Load Balancing
/* resource "google_compute_forwarding_rule" "fw-rule-for-lb" {
 # provider = google-beta
   depends_on = [var.proxy-subnet-id]
#  depends_on  = [google_compute_subnetwork.proxy-subnet] 
  name   = "forwarding-rule-internal-lb"
  region = var.region

  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "8080"
#  target                = google_compute_region_target_http_proxy.default.id
#  target                = var.target-http-proxy_id
  target                = google_compute_region_target_http_proxy.region-target-http-prxy.id
#  network               = google_compute_network.gcp-lab-network.self_link
  network               = var.network_self_link
  subnetwork            = var.subnetwork_id
#  subnetwork            = google_compute_subnetwork.gcp-lab-subnet.id
  network_tier          = "PREMIUM"
} */

