data "template_file" "master" {
  template = "${file("${path.module}/gce_master_startup.sh.tpl")}"
  count = "${var.num_master}"

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
    etcd_endpoints="${var.etcd_endpoints}"
    cluster_dns="${var.cluster_dns}"
    cluster_domain="${var.cluster_domain}"
    cluster_cidr="${var.cluster_cidr}"

    hostname="${var.master_name}-${count.index + 1}"
    internal_ip="10.240.16.2"
    etcd_version="${var.etcd_version}"
    etcd_ips="${join(",", var.etcd_ips)}"
    scheduler_token="${var.scheduler_token}"
    controller_token="${var.controller_token}"
    svc_cluster_ip_range="${var.svc_cluster_ip_range}"
    svc_node_port_range="${var.svc_node_port_range}"
    auth_policy="${file("${path.module}/files/authorization-policy.jsonl")}"
    flannel_backend="${var.flannel_backend}"
    num_master="${var.num_master}"

    kubedns="${data.template_file.kubedns.rendered}"
    kubedashboard="${data.template_file.kubedashboard.rendered}"
    ingress_backend="${data.template_file.ingress_backend.rendered}"
    ingress_rule="${file("${path.module}/templates/addons/ingress/system.yaml")}"
    ingress_controller="${file("${path.module}/templates/addons/ingress/nginx-ingress-controller.yaml")}"
    grafana="${data.template_file.grafana.rendered}"
    heapster="${data.template_file.heapster.rendered}"
    influxdb="${data.template_file.influxdb.rendered}"
    es-controller="${data.template_file.es-controller.rendered}"
    es-service="${file("${path.module}/templates/addons/fluentd/es-service.yaml")}"
    fluentd="${file("${path.module}/templates/addons/fluentd/fluentd-daemonset-elasticsearch.yaml")}"
    kibana-controller="${data.template_file.kibana-controller.rendered}"
    kibana-service="${file("${path.module}/templates/addons/fluentd/kibana-service.yaml")}"
    ca-controller="${data.template_file.ca-controller.rendered}"
    storageclass="${file("${path.module}/files/addons/storageclass/default.yaml")}"
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
    etcd_endpoints="${var.etcd_endpoints}"
    cluster_dns="${var.cluster_dns}"
    cluster_domain="${var.cluster_domain}"
    cluster_cidr="${var.cluster_cidr}"
  }
}

data "template_file" "kubedns" {
  template = "${file("${path.module}/templates/addons/kubedns/kubedns.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "kubedashboard" {
  template = "${file("${path.module}/templates/addons/kubedashboard/kube-dashboard.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "ingress_backend" {
  template = "${file("${path.module}/templates/addons/ingress/default-backend.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "grafana" {
  template = "${file("${path.module}/templates/addons/heapster/grafana.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "heapster" {
  template = "${file("${path.module}/templates/addons/heapster/heapster.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "influxdb" {
  template = "${file("${path.module}/templates/addons/heapster/influxdb.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "es-controller" {
  template = "${file("${path.module}/templates/addons/fluentd/es-controller.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "kibana-controller" {
  template = "${file("${path.module}/templates/addons/fluentd/kibana-controller.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
  }
}

data "template_file" "ca-controller" {
  template = "${file("${path.module}/templates/addons/autoscaler/ca-controller.yaml.tpl")}"

  vars {
    node_name = "${var.master_name}-1"
    project_id = "${var.project_id}"
    gce_zone = "${var.gce_zone}"
    node_group = "${var.node_group}"
  }
}
