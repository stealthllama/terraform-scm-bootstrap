# locals

locals {
    database_script = <<EOF
        #!/bin/bash
        host=updates.paloaltonetworks.com
        while ! ping -q -c 1 $host > /dev/null
        do
        printf "Boo! $${host} is not reachable.\n"
        sleep 1
        done
        ping -oq updates.paloaltonetworks.com
        sudo DEBIAN_FRONTEND=noninteractive apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq debconf-utils mariadb-server
        sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
        sudo systemctl restart mysql
        sudo mysql -e "CREATE DATABASE Demo;"
        sudo mysql -e "CREATE OR REPLACE USER 'demouser'@'%' IDENTIFIED BY 'paloalto@123';"
        sudo mysql -e "GRANT ALL PRIVILEGES ON Demo.* TO 'demouser'@'%';"
        sudo mysql -e "FLUSH PRIVILEGES;"
        EOF

}


# Database server

resource "google_compute_instance" "db_server" {
    name            = "db-server"
    machine_type    = "n1-standard-1"
    zone            = var.zone
    metadata_startup_script = local.database_script
    metadata = {
        serial-port-enable = true
        block-project-ssh-keys = false
    }
    service_account {
      scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
    network_interface {
      subnetwork = google_compute_subnetwork.db_subnet.id
      network_ip = "10.5.3.100"
    }
    boot_disk {
      initialize_params {
        image = "debian-12"
      }
    }
}