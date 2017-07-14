# GCE project ID
variable "project_id" {
  default = "intern-kevin"
}

# GCE region to use.
variable "gce_region" {
  default = "asia-northeast1"
}

# GCE zone to use.
variable "gce_zone" {
  default = "asia-northeast1-b"
}

# GCE network name.
variable "net_name" {
  default = "kubenet"
}

# GCE subnetwork name.
variable "subnet_name" {
  default = "kubesubnet"
}