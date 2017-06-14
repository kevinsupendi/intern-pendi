data "template_file" "etcd_ansible" {
  count = "${var.num_etcd}"
  template = "${file("hostname.tpl")}"
  vars {
    index = "${count.index + 1}"
    name  = "etcd"
    extra = " ansible_host=${element(split(",","${join(",", google_compute_instance.etcd.*.network_interface.0.access_config.0.assigned_nat_ip)}"),count.index)}"
  }
}

data "template_file" "master_ansible" {
  count = "${var.num_master}"
  template = "${file("hostname.tpl")}"
  vars {
    index = "${count.index + 1}"
    name  = "master"
    extra = " ansible_host=${element(split(",","${join(",", google_compute_instance.master.*.network_interface.0.access_config.0.assigned_nat_ip)}"),count.index)}"
  }
}

data "template_file" "node_ansible" {
  count = "${var.num_node}"
  template = "${file("hostname.tpl")}"
  vars {
    index = "${count.index + 1}"
    name  = "node"
    extra = " ansible_host=${element(split(",","${join(",", google_compute_instance.node.*.network_interface.0.access_config.0.assigned_nat_ip)}"),count.index)}"
  }
}

data "template_file" "ansible_hosts" {
  template = "${file("ansible_hosts.tpl")}"
  vars {
    etcd_hosts   = "${join("\n",data.template_file.etcd_ansible.*.rendered)}"
    master_hosts   = "${join("\n",data.template_file.master_ansible.*.rendered)}"
    node_hosts   = "${join("\n",data.template_file.node_ansible.*.rendered)}"
  }
}

output "ansible_inventory" {
	value = "${data.template_file.ansible_hosts.rendered}"
}