module "compute" {
  source = "./modules/compute"
  gce_zone      = "${var.gce_zone}"
  subnet = "${var.subnet_name}"
}

// Configure the Google Cloud provider
provider "google" {
  credentials = "${var.provider_credentials_path}"
  project     = "${var.project_id}"
  region      = "${var.gce_region}"
}

resource "google_compute_network" "network" {
  name                    = "${var.net_name}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.subnet_name}"
  ip_cidr_range = "${var.ip_cidr_range}"
  network       = "${google_compute_network.network.name}"
  region        = "${var.gce_region}"
}

resource "google_compute_firewall" "fw" {
  name = "allow-all"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}
