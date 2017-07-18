# PROJECT
project_id="intern-kevin"

# NETWORK
gce_region="asia-northeast1"
gce_zone="asia-northeast1-b"
net_name="kubenet"
subnet_name="kubesubnet"

# COMPUTE
gce_image="ubuntu-os-cloud/ubuntu-1604-lts"
master_type="n1-standard-1"
master_disk_size=10
tags=["node"]
can_ip_forward="true"
svc_account_scopes=["compute-rw"]
block_project_ssh_keys="true"

# MASTER SCRIPT
etcd_version="3.1.8"
scheduler_token="changeme"
controller_token="changeme"
svc_cluster_ip_range="10.32.0.0/24"
svc_node_port_range="30000-32767"
flannel_backend="vxlan"

# NODE TEMPLATE
template_name="node-template"
node_type="n1-standard-1"
node_group="node-group"
node_group_size=1
base_instance_name="node-group"

# NODE SCRIPT
kubernetes_version="1.6.4"
docker_version="1.11.2"
flannel_version="0.7.0"
kubelet_token="changeme"
cluster_dns="10.32.0.10"
cluster_domain="cluster.local"
cluster_cidr="10.200.0.0/16"

# DONT CHANGE THIS YET
master_name="master"
subnet_ip_cidr_range="10.240.16.0/24"
num_master=1
etcd_ips=["master-1=https://10.240.16.2:2380"]
master_lb_ip="10.240.16.2"
etcd_endpoints="https://10.240.16.2:2379"