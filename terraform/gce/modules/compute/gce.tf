variable "project_id" {}

variable "net_name" {}

variable "gce_zone" {}

variable "subnet" {}

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

variable "etcd_version" {}

variable "etcd_ips" {
  type="list"
}

variable "scheduler_token" {}

variable "controller_token" {}

variable "svc_cluster_ip_range" {}

variable "svc_node_port_range" {}

variable "flannel_backend" {}


resource "google_compute_instance" "master" {
  count = "${var.num_master}"
  name         = "${var.master_name}-${count.index + 1}"
  machine_type = "${var.master_type}"
  zone         = "${var.gce_zone}"

  tags = "${var.tags}"

  disk {
    image = "${var.gce_image}"
    size = "${var.master_disk_size}"
  }

  network_interface {
    subnetwork = "${var.subnet}"
    access_config {
      // Ephemeral IP
    }
  }
 
  can_ip_forward = "${var.can_ip_forward}"
  
  service_account {
    scopes = "${var.svc_account_scopes}"
  }

  metadata {
    block-project-ssh-keys="${var.block_project_ssh_keys}"
    ssh-keys = "pendi:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = "${data.template_file.master.rendered}"
}