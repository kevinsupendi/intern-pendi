# Number of instances to start.
variable "num_etcd" {
   default = "3"
}

# Number of instances to start.
variable "num_master" {
  default = "2"
}

# Number of instances to start.
variable "num_node" {
  default = "3"
}

# GCE region to use.
variable "gce_region" {
  default = "asia-northeast1"
}

# GCE zone to use.
variable "gce_zone" {
  default = "asia-northeast1-b"
}

# GCE image name.
variable "gce_image" {
  default = "ubuntu-os-cloud/ubuntu-1510-wily-v20151021"
}

# GCE network name.
variable "net_name" {
  default = "kubenet"
}

# GCE subnetwork name.
variable "subnet_name" {
  default = "kubesubnet"
}