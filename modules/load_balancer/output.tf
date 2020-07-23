output "backend_service_id" {
#value = google_compute_region_backend_service.instance-group-backendservice.id
value  = google_compute_backend_service.instance-group-backendservice.id
}
output "url-map-id" {
#value = google_compute_region_url_map.LB-region-url-map.id 
value  = google_compute_url_map.LB-url-map.id
}
output "target-http-proxy_id" {
#value = google_compute_region_target_http_proxy.region-target-http-prxy.id   
value  = google_compute_target_http_proxy.target-http-prxy.id
}

/* output "healthcheck_self_link" {
value = google_compute_health_check.http-health-check.self_link   
} */
/* output "healthcheck_self_link" {
value = google_compute_region_health_check.http-healthcheck.self_link   
}  */

output "healthcheck_self_link" {
value = google_compute_health_check.http-healthcheck.self_link   
}

output "LB_name" {
#value = google_compute_region_url_map.LB-region-url-map.name
value  = google_compute_url_map.LB-url-map.name
}
output "LB_ip_address" {
# value = google_compute_forwarding_rule.fw-rule-for-lb.ip_address   
value = google_compute_global_forwarding_rule.fw-rule-for-lb.ip_address
}