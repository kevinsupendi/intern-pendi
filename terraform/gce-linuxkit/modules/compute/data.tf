data "template_file" "kubemaster" {
  template = "${file("${path.module}/templates/kubemaster.yml.tpl")}"
  count = "${var.num_master}"
  vars {
    kubernetes_version = "${var.kubernetes_version}"

    etcd_endpoints="${join(",", formatlist("https://%s:2379",null_resource.masters.*.triggers.ip_lists))}"
    cluster_dns="${cidrhost("${var.svc_cluster_ip_range}", 10)}"
    cluster_domain="${var.cluster_domain}"
    cluster_cidr="${var.cluster_cidr}"

    hostname="${var.master_name}-${count.index + 1}"
    internal_ip="${cidrhost("${var.subnet_ip_cidr_range}","${count.index + var.ip_offset}")}"

    etcd_ips="${join(",", null_resource.masters.*.triggers.etcd_ips)}"
    svc_cluster_ip_range="${var.svc_cluster_ip_range}"
    svc_node_port_range="${var.svc_node_port_range}"
    num_master="${var.num_master}"
  }
}

data "template_file" "kubenode" {
  template = "${file("${path.module}/templates/kubenode.yml.tpl")}"
  vars {
    kubernetes_version = "${var.kubernetes_version}"

    etcd_endpoints="${join(",", formatlist("https://%s:2379",null_resource.masters.*.triggers.ip_lists))}"
    cluster_dns="${cidrhost("${var.svc_cluster_ip_range}", 10)}"
    cluster_domain="${var.cluster_domain}"
    cluster_cidr="${var.cluster_cidr}"
  }
}

data "template_file" "ca-controller" {
  template = "${file("${path.module}/templates/addons/autoscaler/ca-controller.yaml.tpl")}"

  vars {
    project_id = "${var.project_id}"
    gce_zone = "${var.gce_zone}"
    node_group = "${var.node_group}"
  }
}

data "template_file" "kubedns" {
  template = "${file("${path.module}/templates/addons/kubedns/kubedns.yaml.tpl")}"

  vars {
    cluster_ip = "${cidrhost("${var.svc_cluster_ip_range}", 10)}"
  }
}


data "template_file" "certs" {
  template = "${file("${path.module}/templates/certs.sh.tpl")}"

  vars = {
    masters_ip="${join("," , formatlist("\"%s\"",null_resource.masters.*.triggers.ip_lists))}"
    masters_name="${join("," , formatlist("\"%s\"",null_resource.masters.*.triggers.name_lists))}"
    lb_ip="${cidrhost("${var.subnet_ip_cidr_range}", var.lb_offset)}"
    kube_svc="${cidrhost("${var.svc_cluster_ip_range}", 1)}"
  }
}

data "template_file" "gce_conf" {
  template = "${file("${path.module}/templates/gce.conf.tpl")}"

  vars = {
    project_id="${var.project_id}"
    network_name="${var.net_name}"
    tags="${join(",", var.tags)}"
    base_instance_name="${var.base_instance_name}"
  }
}

data "template_file" "kubelet_kubeconfig" {
  template = "${file("${path.module}/templates/kubelet_kubeconfig.tpl")}"

  vars = {
    kubelet_token="${var.kubelet_token}"
    master_lb_ip="${cidrhost("${var.subnet_ip_cidr_range}", var.lb_offset)}"
  }
}