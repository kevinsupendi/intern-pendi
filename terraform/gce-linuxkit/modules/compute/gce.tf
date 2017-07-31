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
    serial-port-enable=1
  }
}

resource "null_resource" "masters" {
  count    = "${var.num_master}"
  triggers {
    ip_lists = "${cidrhost("${var.subnet_ip_cidr_range}", count.index + var.ip_offset)}"
    name_lists = "${var.master_name}-${count.index + 1}"
    etcd_ips = "${var.master_name}-${count.index + 1}=https://${cidrhost("${var.subnet_ip_cidr_range}", count.index + var.ip_offset)}:2380"
  }
}

resource "null_resource" "certs" {
  provisioner "local-exec" {
    command = "${data.template_file.certs.rendered}"
  }
}

resource "null_resource" "gce_conf" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.gce_conf.rendered}' >> gce.conf"
  }
}

resource "null_resource" "kubelet_kubeconfig" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.kubelet_kubeconfig.rendered}' >> kubelet_kubeconfig"
  }
}

resource "null_resource" "kubemaster" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.kubemaster.rendered}' >> kubemaster.yml"
  }
}

resource "null_resource" "kubenode" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.kubenode.rendered}' >> kubenode.yml"
  }
}