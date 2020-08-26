output "google_cidr_blocks" {
  value = data.google_netblock_ip_ranges.google.cidr_blocks
}

output "google_cloud_cidr_blocks" {
  value = data.google_netblock_ip_ranges.google_cloud.cidr_blocks
}

output "google_security_policy" {
  value = google_compute_security_policy.google.self_link
}

output "google_cloud_security_policy" {
  value = google_compute_security_policy.google_cloud.self_link
}
