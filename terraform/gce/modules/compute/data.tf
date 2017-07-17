data "template_file" "master" {
  template = "${file("${path.module}/gce_master_startup.sh.tpl")}"

  vars {
    kubernetes_version = "${var.kubernetes_version}"
    docker_version="${var.docker_version}"
    flannel_version="${var.flannel_version}"

    project_id="${var.project_id}"
    network_name="${var.net_name}"
    tags="${join(",", var.tags)}"
    base_instance_name="${var.base_instance_name}"
    kubelet_token="${var.kubelet_token}"
    master_lb_ip="${var.master_lb_ip}"
    flannel_etcd_endpoints="${var.flannel_etcd_endpoints}"
    cluster_dns="${var.cluster_dns}"
    cluster_domain="${var.cluster_domain}"
    cluster_cidr="${var.cluster_cidr}"
  }
}

data "template_file" "node" {
  template = "${file("${path.module}/gce_template_startup.sh.tpl")}"

  vars {
    kubernetes_version = "${var.kubernetes_version}"
    docker_version="${var.docker_version}"
    flannel_version="${var.flannel_version}"

    project_id="${var.project_id}"
    network_name="${var.net_name}"
    tags="${join(",", var.tags)}"
    base_instance_name="${var.base_instance_name}"
    kubelet_token="${var.kubelet_token}"
    master_lb_ip="${var.master_lb_ip}"
    flannel_etcd_endpoints="${var.flannel_etcd_endpoints}"
    cluster_dns="${var.cluster_dns}"
    cluster_domain="${var.cluster_domain}"
    cluster_cidr="${var.cluster_cidr}"
  }
}