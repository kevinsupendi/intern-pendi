resource "google_compute_image" "kubemaster" {
  name = "kubemaster"
  depends_on = ["null_resource.master_image"]
  raw_disk {
    source = "https://storage.googleapis.com/pendi/kubemaster.img.tar.gz"
  }
}

resource "google_compute_image" "kubenode" {
  name = "kubenode"
  depends_on = ["null_resource.node_image"]
  raw_disk {
    source = "https://storage.googleapis.com/pendi/kubenode.img.tar.gz"
  }
}

resource "google_compute_instance" "master" {
  count = "${var.num_master}"
  name         = "${var.master_name}-${count.index + 1}"
  project = "${var.project_id}"
  machine_type = "${var.master_type}"
  zone         = "${var.gce_zone}"

  tags = "${var.tags}"

  disk {
    image = "${google_compute_image.kubemaster.self_link}"
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
    command = "echo '${data.template_file.gce_conf.rendered}' > ${path.module}/temp/gce.conf"
  }
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.kubeconfig.rendered}' > ${path.module}/temp/kubeconfig"
  }
}

resource "null_resource" "token" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.token.rendered}' > ${path.module}/temp/token.csv"
  }
}

resource "null_resource" "kubemaster" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.kubemaster.rendered}' > ${path.module}/temp/kubemaster.yml"
  }
}

resource "null_resource" "kubenode" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.kubenode.rendered}' > ${path.module}/temp/kubenode.yml"
  }
}

resource "null_resource" "node_image" {
  depends_on = ["null_resource.kubenode","null_resource.certs","null_resource.kubeconfig","null_resource.gce_conf"]
  provisioner "local-exec" {
    command = "moby build -output gcp ${path.module}/temp/kubenode.yml && linuxkit push gcp -project intern-kevin -bucket pendi kubenode.img.tar.gz"
  }
}

resource "null_resource" "master_image" {
  depends_on = ["null_resource.kubemaster","null_resource.certs","null_resource.kubeconfig","null_resource.gce_conf","null_resource.token"]
  provisioner "local-exec" {
    command = "moby build -output gcp ${path.module}/temp/kubemaster.yml && linuxkit push gcp -project intern-kevin -bucket pendi kubemaster.img.tar.gz"
  }
}