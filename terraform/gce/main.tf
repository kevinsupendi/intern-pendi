module "compute" {
  source = "./modules/compute"
  gce_zone      = "${var.gce_zone}"
  subnet = "${google_compute_subnetwork.subnet.name}"
  net_name="${var.net_name}"
  project_id="${var.project_id}"

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
  master_lb_ip="${var.master_lb_ip}"
  etcd_endpoints="${var.etcd_endpoints}"
  cluster_dns="${var.cluster_dns}"
  cluster_domain="${var.cluster_domain}"
  cluster_cidr="${var.cluster_cidr}"

  etcd_version="${var.etcd_version}"
  etcd_ips="${var.etcd_ips}"
  scheduler_token="${var.scheduler_token}"
  controller_token="${var.controller_token}"
  svc_cluster_ip_range="${var.svc_cluster_ip_range}"
  svc_node_port_range="${var.svc_node_port_range}"
  flannel_backend="${var.flannel_backend}"
}


variable "project_id" {}

variable "subnet_ip_cidr_range" {}

variable "gce_region" {}

variable "gce_zone" {}

variable "net_name" {}

variable "subnet_name" {}

variable "gce_image" {}

variable "num_master" {}

variable "master_name" {}

variable "master_type" {}

variable "master_disk_size" {}

variable "tags" {
  type = "list"
}

variable "can_ip_forward" {}

variable "svc_account_scopes" {
  type = "list"
}

variable "block_project_ssh_keys" {}

variable "node_type" {}

variable "node_group" {}

variable "node_group_size" {}

variable "base_instance_name" {}

variable "template_name" {}

variable "kubernetes_version" {}

variable "docker_version" {}

variable "flannel_version" {}

variable "kubelet_token" {}

variable "master_lb_ip" {}

variable "etcd_endpoints" {}

variable "cluster_dns" {}

variable "cluster_domain" {}

variable "cluster_cidr" {}

variable "etcd_version" {}

variable "etcd_ips" {
  type="list"
}

variable "scheduler_token" {}

variable "controller_token" {}

variable "svc_cluster_ip_range" {}

variable "svc_node_port_range" {}

variable "flannel_backend" {}


# Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/svc_account/account.json")}"
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
