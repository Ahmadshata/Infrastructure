output "vpc-uri" {
  value = google_compute_network.net.self_link
}
output "subnet-uri" {
  value = google_compute_subnetwork.subnet.self_link
}