# Locals
locals {
  bootstrap_options = {
    type                = "dhcp-client"
    panorama-server     = "cloud"
    tplname             = "label:${var.label}"
    plugin-op-commands  = "advance-routing:enable"
    vm-series-auto-registration-pin-id  = var.cert-pin-id
    vm-series-auto-registration-pin-value = var.cert-pin-value
    authcodes           = var.authcodes
  }
  ssh_key = "admin:ssh-rsa ${var.ssh_public_key} admin"
}


# Firewall
resource "google_compute_instance" "firewall_instance" {
  name = "demo-firewall"
  description = "Demo firewall"
  zone = var.zone
  machine_type = "n2-standard-4"
  min_cpu_platform = "Intel Cascade Lake"
  can_ip_forward = true
  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-flex-byol-1120"
    }
  }
  service_account {
    scopes = [
        "https://www.googleapis.com/auth/compute.readonly",
        "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring.write",
      ]
  }
  network_interface {
    subnetwork        = google_compute_subnetwork.mgmt_subnet.id
    network_ip        = "10.5.0.2"
    access_config {
      // Ephemeral public IP
    }
  }
  network_interface {
    subnetwork        = google_compute_subnetwork.untrust_subnet.id
    network_ip        = "10.5.1.2"
    access_config {
      // Ephemeral public IP
    }
  }
  network_interface {
    subnetwork        = google_compute_subnetwork.app_subnet.id
    network_ip        = "10.5.2.2"
  }
  network_interface {
    subnetwork        = google_compute_subnetwork.db_subnet.id
    network_ip        = "10.5.3.2"
  }
  metadata = merge(
    {
      serial-port-enable      = true
      block-project-ssh-keys  = true
      ssh-keys                = local.ssh_key
    },
    local.bootstrap_options
  )
}
