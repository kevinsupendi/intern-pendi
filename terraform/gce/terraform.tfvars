# PROJECT
project_id="intern-kevin"
cred_path="~/svc_account/account.json"

# NETWORK
gce_region="asia-northeast1"
gce_zone="asia-northeast1-b"
net_name="kubenet"
subnet_name="kubesubnet"
subnet_ip_cidr_range="10.240.16.0/24"

# COMPUTE
gce_image="ubuntu-os-cloud/ubuntu-1604-lts"
master_name="master"
master_type="n1-standard-1"
num_master=1
master_disk_size=10
tags=["node"]
can_ip_forward="true"
svc_account_scopes=["compute-rw"]
block_project_ssh_keys="true"

# MASTER SCRIPT
ip_offset = 4
lb_offset = 3
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