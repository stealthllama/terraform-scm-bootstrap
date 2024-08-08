# Outputs

output "firewall-instance" {
  value = "${google_compute_instance.firewall_instance.self_link}"
  description = "Firewall link"
}

output "firewall-public-ip" {
  value = "${google_compute_instance.firewall_instance.network_interface.0.access_config.0.nat_ip}"
  description = "The public IP address of the firewall management interface"
}

output "web-public-ip" {
  value = "${google_compute_instance.firewall_instance.network_interface.1.access_config.0.nat_ip}"
  description = "The public IP address of the firewall untrust interface"
}
