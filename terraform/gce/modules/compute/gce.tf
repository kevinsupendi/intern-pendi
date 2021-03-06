resource "google_compute_instance" "master" {
  count = "${var.num_master}"
  name         = "${var.master_name}-${count.index + 1}"
  project = "${var.project_id}"
  machine_type = "${var.master_type}"
  zone         = "${var.gce_zone}"

  tags = "${var.tags}"

  disk {
    image = "${var.gce_image}"
    size = "${var.master_disk_size}"
  }

  network_interface {
    subnetwork = "${var.subnet}"
    address = "${cidrhost("${var.subnet_ip_cidr_range}","${count.index + var.ip_offset}")}"
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
  }

  metadata_startup_script = "${element(data.template_file.master.*.rendered, count.index)}"
}

resource "null_resource" "masters" {
  count    = "${var.num_master}"
  triggers {
    ip_lists = "${cidrhost("${var.subnet_ip_cidr_range}", count.index + var.ip_offset)}"
    name_lists = "${var.master_name}-${count.index + 1}"
    etcd_ips = "${var.master_name}-${count.index + 1}=https://${cidrhost("${var.subnet_ip_cidr_range}", count.index + var.ip_offset)}:2380"
  }
}