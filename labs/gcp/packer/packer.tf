resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "packer-ubuntu-1604"
    }
  }

shielded_instance_config {
  enable_vtpm = true
}
  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo Hello from packer > /test.txt"
}
