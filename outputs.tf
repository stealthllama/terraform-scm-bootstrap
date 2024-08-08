# Outputs

output "firewall-mgmt-ip" {
  value = "${google_compute_instance.firewall_instance.network_interface.0.access_config.0.nat_ip}"
  description = "The public IP address of the firewall management interface"
}

output "firewall-untrust-ip" {
  value = "${google_compute_instance.firewall_instance.network_interface.1.access_config.0.nat_ip}"
  description = "The public IP address of the firewall untrust interface"
}
