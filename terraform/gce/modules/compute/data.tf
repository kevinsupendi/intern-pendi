data "template_file" "master" {
  template = "${file("${path.module}/gce_master_startup")}"
  count = "${var.num_master}"
  vars {
    capem = "${data.external.certs.result["capem"]}"
    kubernetespem = "${data.external.certs.result["kubernetespem"]}"
    kuberneteskeypem = "${data.external.certs.result["kuberneteskeypem"]}"

    kubernetes_version = "${var.kubernetes_version}"
    docker_version="${var.docker_version}"
    flannel_version="${var.flannel_version}"

    project_id="${var.project_id}"
    network_name="${var.net_name}"
    tags="${join(",", var.tags)}"
    base_instance_name="${var.base_instance_name}"
    kubelet_token="${var.kubelet_token}"
    master_lb_ip="${cidrhost("${var.subnet_ip_cidr_range}", var.lb_offset)}"
    etcd_endpoints="${join(",", formatlist("https://%s:2379",null_resource.masters.*.triggers.ip_lists))}"
    cluster_dns="${cidrhost("${var.svc_cluster_ip_range}", 10)}"
    cluster_domain="${var.cluster_domain}"
    cluster_cidr="${var.cluster_cidr}"

    hostname="${var.master_name}-${count.index + 1}"
    internal_ip="${cidrhost("${var.subnet_ip_cidr_range}","${count.index + var.ip_offset}")}"
    etcd_version="${var.etcd_version}"
    etcd_ips="${join(",", null_resource.masters.*.triggers.etcd_ips)}"
    scheduler_token="${var.scheduler_token}"
    controller_token="${var.controller_token}"
    svc_cluster_ip_range="${var.svc_cluster_ip_range}"
    svc_node_port_range="${var.svc_node_port_range}"
    auth_policy="${file("${path.module}/files/authorization-policy.jsonl")}"
    flannel_backend="${var.flannel_backend}"
    num_master="${var.num_master}"

    kubedns="${data.template_file.kubedns.rendered}"
    kubedashboard="${file("${path.module}/files/addons/kubedashboard/kube-dashboard.yaml")}"
    ingress_backend="${file("${path.module}/files/addons/ingress/default-backend.yaml")}"
    ingress_rule="${file("${path.module}/files/addons/ingress/system.yaml")}"
    ingress_controller="${file("${path.module}/files/addons/ingress/nginx-ingress-controller.yaml")}"
    grafana="${file("${path.module}/files/addons/heapster/grafana.yaml")}"
    heapster="${file("${path.module}/files/addons/heapster/heapster.yaml")}"
    influxdb="${file("${path.module}/files/addons/heapster/influxdb.yaml")}"
    es-controller="${file("${path.module}/files/addons/fluentd/es-controller.yaml")}"
    es-service="${file("${path.module}/files/addons/fluentd/es-service.yaml")}"
    fluentd="${file("${path.module}/files/addons/fluentd/fluentd-daemonset-elasticsearch.yaml")}"
    kibana-controller="${file("${path.module}/files/addons/fluentd/kibana-controller.yaml")}"
    kibana-service="${file("${path.module}/files/addons/fluentd/kibana-service.yaml")}"
    ca-controller="${data.template_file.ca-controller.rendered}"
    storageclass="${file("${path.module}/files/addons/storageclass/default.yaml")}"
  }
}

data "template_file" "node" {
  template = "${file("${path.module}/gce_template_startup")}"
  vars {
    capem = "${data.external.certs.result["capem"]}"
    kubernetespem = "${data.external.certs.result["kubernetespem"]}"
    kuberneteskeypem = "${data.external.certs.result["kuberneteskeypem"]}"

    kubernetes_version = "${var.kubernetes_version}"
    docker_version="${var.docker_version}"
    flannel_version="${var.flannel_version}"

    project_id="${var.project_id}"
    network_name="${var.net_name}"
    tags="${join(",", var.tags)}"
    base_instance_name="${var.base_instance_name}"
    etcd_endpoints="${join(",", formatlist("https://%s:2379",null_resource.masters.*.triggers.ip_lists))}"
    kubelet_token="${var.kubelet_token}"
    master_lb_ip="${cidrhost("${var.subnet_ip_cidr_range}", var.lb_offset)}"
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


data "external" "certs" {
  program = ["bash","${path.module}/certs.sh"]

  query = {
    masters_ip="${join("," , formatlist("\"%s\"",null_resource.masters.*.triggers.ip_lists))}"
    masters_name="${join("," , formatlist("\"%s\"",null_resource.masters.*.triggers.name_lists))}"
    lb_ip="${cidrhost("${var.subnet_ip_cidr_range}", var.lb_offset)}"
    kube_svc="${cidrhost("${var.svc_cluster_ip_range}", 1)}"
  }
}