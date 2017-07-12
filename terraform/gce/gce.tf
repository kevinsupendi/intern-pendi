// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/svc_account/account.json")}"
  project     = "intern-kevin"
  region      = "${var.gce_region}"
}

// Create master instances
resource "google_compute_instance" "master" {
  count = "${var.num_master}"
  name         = "master-${count.index + 1}"
  machine_type = "n1-standard-1"
  zone         = "${var.gce_zone}"

  tags = ["node"]

  disk {
    image = "${var.gce_image}"
    size = 10
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet.name}"
    access_config {
      // Ephemeral IP
    }
  }
 
  can_ip_forward = "true"
  
  service_account {
    scopes = ["compute-rw"]
  }

  metadata {
    block-project-ssh-keys="true"
    ssh-keys = "pendi:${file("~/.ssh/id_rsa.pub")}"
  }
}