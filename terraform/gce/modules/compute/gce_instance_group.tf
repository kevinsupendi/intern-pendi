resource "google_compute_instance_template" "igm" {
  name        = "node-template"

  tags = ["node"]
  machine_type         = "n1-standard-1"
  can_ip_forward       = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "${var.gce_image}"
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
    block-project-ssh-keys="true"
    ssh-keys = "pendi:${file("~/.ssh/id_rsa.pub")}"
  }

  service_account {
    scopes = ["compute-rw"]
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_startup_script = "${file("${path.module}/gce_template_startup.sh")}"
}


resource "google_compute_instance_group_manager" "igm" {
  name        = "node-group"

  base_instance_name = "node-group"
  instance_template  = "${google_compute_instance_template.igm.self_link}"
  update_strategy    = "NONE"
  zone               = "asia-northeast1-b"

  target_size  = 1
}
