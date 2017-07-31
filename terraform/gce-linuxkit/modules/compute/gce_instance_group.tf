
resource "google_compute_instance_template" "igm" {
  name        = "${var.template_name}"
  project = "${var.project_id}"
  region = "${var.gce_region}"
  tags = "${var.tags}"
  machine_type         = "${var.node_type}"
  can_ip_forward       = "${var.can_ip_forward}"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "projects/intern-kevin/global/images/kubenode"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = "${var.subnet}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    block-project-ssh-keys="${var.block_project_ssh_keys}"
    serial-port-enable=1
  }

  service_account {
    scopes = "${var.svc_account_scopes}"
  }

  lifecycle {
    create_before_destroy = true
  }

}


resource "google_compute_instance_group_manager" "igm" {
  name        = "${var.node_group}"

  base_instance_name = "${var.base_instance_name}"
  instance_template  = "${google_compute_instance_template.igm.self_link}"
  update_strategy    = "NONE"
  zone               = "${var.gce_zone}"

  target_size  = "${var.node_group_size}"
}

resource "google_compute_instance_group" "masters" {
  name        = "masters"

  instances = ["${google_compute_instance.master.*.self_link}"]

  zone = "${var.gce_zone}"
}