# Locals

locals {
    # wordpress_config = <<EOF
    #     <?php
    #     # Created by /usr/share/doc/wordpress/examples/setup-mysql 
    #     define('DB_NAME', 'Demo');
    #     define('DB_USER', 'demouser');
    #     define('DB_PASSWORD', 'paloalto@123');
    #     define('DB_HOST', '10.5.3.100');
    #     define('SECRET_KEY', 'UtqouIbh65q92QYevFJzth5Kuya3GKozJzmOq4Mv0mevSmgtlW');
    #     define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');
    #     ?>
    #     EOF
    app_script = <<EOF
        #!/bin/bash
        host=updates.paloaltonetworks.com
        while ! ping -q -c 1 $host > /dev/null
        do
        printf "Boo! $${host} is not reachable.\n"
        sleep 1
        done
        sudo DEBIAN_FRONTEND=noninteractive apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 wordpress
        sudo mount --bind /usr/share/wordpress/ /var/www/html/
        #echo ${local.wordpress_config} | sudo tee /etc/wordpress/config-default.php
        sudo cat <<END > /etc/wordpress/config-default.php
        <?php
        # Created by /usr/share/doc/wordpress/examples/setup-mysql 
        define('DB_NAME', 'Demo');
        define('DB_USER', 'demouser');
        define('DB_PASSWORD', 'paloalto@123');
        define('DB_HOST', '10.5.3.100');
        define('SECRET_KEY', 'UtqouIbh65q92QYevFJzth5Kuya3GKozJzmOq4Mv0mevSmgtlW');
        define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');
        ?>
        END
        sudo chown root:www-data /etc/wordpress/config-default.php
        EOF
}



resource "google_compute_instance" "app_server" {
    name            = "app-server"
    machine_type    = "n1-standard-1"
    zone            = var.zone
    metadata_startup_script = local.app_script
    metadata = {
        serial-port-enable = true
        block-project-ssh-keys = false
    }
    service_account {
      scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
    network_interface {
      subnetwork = google_compute_subnetwork.app_subnet.id
      network_ip = "10.5.2.100"
    }
    boot_disk {
      initialize_params {
        image = "debian-12"
      }
    }
}