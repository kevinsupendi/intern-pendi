output "masters_backend" {
  value = "${google_compute_instance_group.masters.self_link}"
}