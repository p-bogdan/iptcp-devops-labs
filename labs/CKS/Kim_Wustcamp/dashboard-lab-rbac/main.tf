# data "google_compute_instance" "dashboard" {
#   name = google_compute_instance.dashboard.instance_id
#   zone = "us-central1-a"
# }

resource "google_compute_firewall" "dashboard" {
  name    = "open"
  network = "default"

  allow {
    ports = ["22", "30000-40000"]
    protocol = "tcp"
    #ports    = ["80", "8080", "1000-2000"]
  }

source_ranges = ["0.0.0.0/0"]
  target_tags = ["open"]
}

resource "google_compute_instance" "dashboard" {
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

resource "null_resource" "dashboard" {
  depends_on = [google_compute_instance.dashboard]
   provisioner "file" {
    source      = "dashboard-2.7.0.yaml"
    destination = "/tmp/dashboard-2.7.0.yaml"
   
  }
  connection {
    agent    = false
    type     = "ssh"
    user     = "iptcp"
    private_key = "${file("~/.ssh/google_compute_engine")}"
    #host = element(self[*].network_interface.0.access_config.0.nat_ip, 0)
    #host = element(google_compute_instance.dashboard[*].network_interface.0.access_config.0.nat_ip, 0)
    host = google_compute_instance.dashboard["k8s-master"].network_interface.0.access_config.0.nat_ip
    #password = "${var.root_password}"
    #host     = "${var.host}"
  }

  #triggers = {
  #  "after" = element(google_compute_instance.dashboard[*].instance_id, 0)
  #}
}