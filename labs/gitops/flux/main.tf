resource "google_compute_firewall" "default" {
  name    = "open"
  network = "default"

  allow {
    ports = ["22", "6443","32000"]
    protocol = "tcp"
    #ports    = ["80", "8080", "1000-2000"]
  }

source_ranges = ["92.60.179.185/32", "37.57.124.38/32"]
  target_tags = ["open"]
}

resource "google_compute_instance" "default" {
  for_each = var.k8s_nodes
  name         = "${each.value.name}"
  machine_type = "e2-medium"
  zone         = "us-west1-b"

  tags = ["open"]

  boot_disk {
    initialize_params {
      size  = "50"
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("${each.value.startup_script}")
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "la-lab@ci-cd-387713.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}