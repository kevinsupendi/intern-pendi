variable "project_id" {}

variable "net_name" {}

variable "gce_zone" {}

variable "gce_region" {}

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

variable "scheduler_token" {}

variable "controller_token" {}

variable "svc_cluster_ip_range" {}

variable "svc_node_port_range" {}

variable "flannel_backend" {}

variable "template_name" {}

variable "node_type" {}

variable "node_group" {}

variable "node_group_size" {}

variable "base_instance_name" {}

variable "kubernetes_version" {}

variable "docker_version" {}

variable "flannel_version" {}

variable "kubelet_token" {}

variable "lb_offset" {}

variable "cluster_domain" {}

variable "cluster_cidr" {}

variable "subnet_ip_cidr_range" {}

variable "ip_offset" {}