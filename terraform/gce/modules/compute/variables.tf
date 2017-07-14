# Number of instances to start.
variable "num_master" {
  default = "1"
}

# Number of instances to start.
variable "num_node" {
  default = "1"
}


# GCE image name.
variable "gce_image" {
  default = "ubuntu-os-cloud/ubuntu-1604-lts"
}

# Variable from network
variable "gce_zone" {}
variable "subnet" {}