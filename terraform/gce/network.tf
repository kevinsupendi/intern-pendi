resource "google_compute_network" "network" {
  name                    = "${var.net_name}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.subnet_name}"
  ip_cidr_range = "10.240.16.0/24"
  network       = "${google_compute_network.network.name}"
  region        = "${var.gce_region}"
}

resource "google_compute_firewall" "firewall" {
  name = "allowall"
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

resource "google_compute_route" "kube" {
  count = "${var.num_node}"
  name        = "kuberoute-${count.index}"
  dest_range  = "10.200.${count.index}.0/24"
  network     = "${google_compute_network.network.name}"
  next_hop_ip = "${google_compute_instance.node.*.network_interface.0.address[count.index]}"
  priority    = 1000
}