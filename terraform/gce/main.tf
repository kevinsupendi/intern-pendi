module "compute" {
  source = "./modules/compute"
  gce_zone      = "${var.gce_zone}"
  gce_region      = "${var.gce_region}"
  subnet = "${google_compute_subnetwork.subnet.name}"
  net_name="${var.net_name}"
  project_id="${var.project_id}"
  subnet_ip_cidr_range="${var.subnet_ip_cidr_range}"
  ip_offset="${var.ip_offset}"

  gce_image="${var.gce_image}"
  num_master="${var.num_master}"
  master_name="${var.master_name}"
  master_type="${var.master_type}"
  master_disk_size="${var.master_disk_size}"
  tags="${var.tags}"
  can_ip_forward="${var.can_ip_forward}"
  svc_account_scopes="${var.svc_account_scopes}"
  block_project_ssh_keys="${var.block_project_ssh_keys}"
  template_name="${var.template_name}"
  node_type="${var.node_type}"
  node_group="${var.node_group}"
  node_group_size="${var.node_group_size}"
  base_instance_name="${var.base_instance_name}"

  kubernetes_version = "${var.kubernetes_version}"
  docker_version="${var.docker_version}"
  flannel_version="${var.flannel_version}"
  kubelet_token="${var.kubelet_token}"
  lb_offset="${var.num_master > 1 ? var.lb_offset : var.ip_offset}"
  cluster_domain="${var.cluster_domain}"
  cluster_cidr="${var.cluster_cidr}"

  etcd_version="${var.etcd_version}"
  scheduler_token="${var.scheduler_token}"
  controller_token="${var.controller_token}"
  svc_cluster_ip_range="${var.svc_cluster_ip_range}"
  svc_node_port_range="${var.svc_node_port_range}"
  flannel_backend="${var.flannel_backend}"
}


# Configure the Google Cloud provider
provider "google" {
  credentials = "${file("${var.cred_path}")}"
  project     = "${var.project_id}"
  region      = "${var.gce_region}"
}

resource "google_compute_network" "network" {
  name                    = "${var.net_name}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.subnet_name}"
  ip_cidr_range = "${var.subnet_ip_cidr_range}"
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

resource "google_compute_forwarding_rule" "master_lb" {
  count = "${var.num_master > 1 ? 1 : 0}"
  name       = "master-lb"
  backend_service = "${google_compute_region_backend_service.masters.self_link}"
  ip_address = "${cidrhost("${var.subnet_ip_cidr_range}", var.lb_offset)}"
  load_balancing_scheme = "INTERNAL"
  network = "${google_compute_network.network.self_link}"
  ports = ["6443", "80", "443","8080"]
  subnetwork = "${google_compute_subnetwork.subnet.self_link}"
}

resource "google_compute_region_backend_service" "masters" {
  name        = "masters"
  count = "${var.num_master > 1 ? 1 : 0}"
  backend {
    group = "${module.compute.masters_backend}"
  }

  health_checks = ["${google_compute_health_check.default.self_link}"]
}

resource "google_compute_health_check" "default" {
  name = "masters"
  count = "${var.num_master > 1 ? 1 : 0}"
  https_health_check {
    port = "6443"
    request_path = "/healthz"
  }
}