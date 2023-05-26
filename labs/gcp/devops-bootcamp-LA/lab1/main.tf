resource "google_compute_instance" "default" {
  name         = "ci"
  machine_type = "e2-medium"
  zone         = "us-west1-b"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      size  = "20"
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
#  scratch_disk {
#    interface = "SCSI"
#  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "la-lab@ci-cd-387713.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}