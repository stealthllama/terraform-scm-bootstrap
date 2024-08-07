# Network and subnets

resource "google_compute_network" "mgmt_network" {
  name = "mgmt-network"
  description = "Management network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mgmt_subnet" {
  name = "mgmt-subnet"
  description = "Management subnet"
  ip_cidr_range = "10.5.0.0/24"
  network = google_compute_network.mgmt_network.id
}

resource "google_compute_network" "untrust_network" {
  name = "untrust-network"
  description = "Untrust network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "untrust_subnet" {
  name = "untrust-subnet"
  description = "Untrust subnet"
  ip_cidr_range = "10.5.1.0/24"
  network = google_compute_network.untrust_network.id
}

resource "google_compute_network" "app_network" {
  name = "app-network"
  description = "Application network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "app_subnet" {
  name = "app-subnet"
  description = "Application subnet"
  ip_cidr_range = "10.5.2.0/24"
  network = google_compute_network.app_network.id
}

resource "google_compute_network" "db_network" {
  name = "db-network"
  description = "Database network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "db_subnet" {
  name = "db-subnet"
  description = "Database subnet"
  ip_cidr_range = "10.5.3.0/24"
  network = google_compute_network.db_network.id
}


# Firewall rules

resource "google_compute_firewall" "mgmt_firewall" {
  name    = "mgmt-allow-inbound"
  network = google_compute_network.mgmt_network.id
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["443", "22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "untrust_firewall" {
  name    = "untrust-allow-inbound"
  network = google_compute_network.untrust_network.id
  allow {
    protocol = "tcp"
    ports    = ["80", "22", "221", "222"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "app_firewall" {
  name    = "app-allow-outbound"
  network = google_compute_network.app_network.id
  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "db_firewall" {
  name    = "db-allow-outbound"
  network = google_compute_network.db_network.id
  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
}


# Routes
resource "google_compute_route" "app_route" {
  name        = "app-route"
  dest_range  = "0.0.0.0/0"
  network     = google_compute_network.app_network.id
  next_hop_instance = google_compute_instance.firewall_instance.self_link
#   next_hop_ip = "10.5.2.2"
  priority    = 500
}

resource "google_compute_route" "db_route" {
  name        = "db-route"
  dest_range  = "0.0.0.0/0"
  network     = google_compute_network.db_network.id
  next_hop_instance = google_compute_instance.firewall_instance.self_link
#   next_hop_ip = "10.5.3.2"
  priority    = 500
}