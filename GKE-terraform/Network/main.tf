resource "google_compute_network" "net" {
  name = var.vpc-name
  auto_create_subnetworks         = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet-name
  private_ip_google_access = var.private-google-access
  network       = google_compute_network.net.id
  ip_cidr_range = var.subnet-cidr
  region        = var.subnet-region
  secondary_ip_range {
    range_name    = var.secondary-ip-range-1-name
    ip_cidr_range = var.secondary-ip-range-1-cidr
  }
  secondary_ip_range {
    range_name    = var.secondary-ip-range-2-name
    ip_cidr_range = var.secondary-ip-range-2-cidr
  }
}

resource "google_compute_router" "router" {
  name    = var.router-name
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.net.id

  bgp {
    asn = 64514
    keepalive_interval = var.bgp-keepalive
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = var.nat-name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = var.nat-ip-allocation
  source_subnetwork_ip_ranges_to_nat = var.source-subnet-ranges

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.net.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.subnet-cidr, "156.203.127.199/32"]
}