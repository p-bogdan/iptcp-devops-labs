resource "google_kms_key_ring" "keyring" {
  name     = "keyring-example"
  location = "global"
}

resource "google_kms_crypto_key" "example-key" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"


  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "packer-ubuntu-1604"
    }
    kms_key_self_link = google_kms_crypto_key.example-key.self_link
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

  }

  metadata = {
    foo                    = "bar"
    block-project-ssh-keys = true
  }

  metadata_startup_script = "echo Hello from packer > /test.txt"
}
