variable "template_name" {}

variable "node_type" {}

variable "node_group" {}

variable "node_group_size" {}

variable "base_instance_name" {}

variable "kubernetes_version" {}

variable "docker_version" {}

variable "flannel_version" {}

variable "kubelet_token" {}

variable "master_lb_ip" {}

variable "flannel_etcd_endpoints" {}

variable "cluster_dns" {}

variable "cluster_domain" {}

variable "cluster_cidr" {}


resource "google_compute_instance_template" "igm" {
  name        = "${var.template_name}"

  tags = "${var.tags}"
  machine_type         = "${var.node_type}"
  can_ip_forward       = "${var.can_ip_forward}"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "${var.gce_image}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = "${var.subnet}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    block-project-ssh-keys="${var.block_project_ssh_keys}"
    ssh-keys = "pendi:${file("~/.ssh/id_rsa.pub")}"
  }

  service_account {
    scopes = "${var.svc_account_scopes}"
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_startup_script = "#! /bin/bash\n\n#Generate certificates\n\necho 'capem' > ca.pem\necho 'kubernetespem' > kubernetes.pem\necho 'kuberneteskeypem' > kubernetes-key.pem\n\nmkdir /var/lib/kubernetes\nmv ca.pem /var/lib/kubernetes/ca.pem\nmv kubernetes.pem /var/lib/kubernetes/kubernetes.pem\nmv kubernetes-key.pem /var/lib/kubernetes/kubernetes-key.pem\n\n#Install Flanneld\nwget https://github.com/coreos/flannel/releases/download/v0.7.0/flannel-v0.7.0-linux-amd64.tar.gz\ntar -xf flannel-v0.7.0-linux-amd64.tar.gz\nchmod +x flanneld\nsudo mv flanneld /usr/bin/flanneld\n\n#Install Docker\nwget https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz\ntar -xf docker-1.11.2.tgz\nsudo cp docker/docker* /usr/bin/\n\n\n#Install Kubelet\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubelet\nchmod +x kubelet\nsudo mv kubelet /usr/bin/kubelet\n\n\n#Install Kube-proxy\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-proxy\nchmod +x kube-proxy\nsudo mv kube-proxy /usr/bin/kube-proxy\n\n#Create gce.conf\ncat > gce.conf <<EOF\n[Global]\nproject-id=intern-kevin\nnetwork-name=kubenet\nnode-tags=node\nnode-instance-prefix=node-group\nEOF\n\nsudo mv gce.conf /var/lib/kubernetes/gce.conf\n\n#Create kubeconfig\ncat > kubeconfig <<EOF\napiVersion: v1\nkind: Config\nclusters:\n- cluster:\n    certificate-authority: /var/lib/kubernetes/ca.pem\n    server: https://10.240.16.2:6443\n  name: kubernetes\ncontexts:\n- context:\n    cluster: kubernetes\n    user: kubelet\n  name: kubelet\ncurrent-context: kubelet\nusers:\n- name: kubelet\n  user:\n    token: changeme\nEOF\n\nsudo mkdir /var/lib/kubelet\nsudo mv kubeconfig /var/lib/kubelet/kubeconfig\n\n#Create systemd files\n\ncat > flannel.service <<EOF\n[Unit]\nDescription=Flannel\nDocumentation=https://github.com/coreos/flannel\n\n[Service]\nExecStart=/usr/bin/flanneld --etcd-endpoints=https://10.240.16.2:2379 \\\\\n  --etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem \\\\\n  --etcd-certfile=/var/lib/kubernetes/kubernetes.pem \\\\\n  --etcd-cafile=/var/lib/kubernetes/ca.pem \\\\\n  --ip-masq=true\n\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > docker.service <<EOF\n[Unit]\nDescription=Docker Application Container Engine\nDocumentation=http://docs.docker.io\nAfter=flannel.service\nRequires=flannel.service\n\n[Service]\nEnvironmentFile=/run/flannel/subnet.env\nExecStart=/usr/bin/docker daemon --bip=\\$${FLANNEL_SUBNET} --mtu=\\$${FLANNEL_MTU}  --iptables=false   --ip-masq=false   --host=unix:///var/run/docker.sock   --log-level=error   --storage-driver=overlay\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > kubelet.service <<EOF\n[Unit]\nDescription=Kubernetes Kubelet\nDocumentation=https://github.com/GoogleCloudPlatform/kubernetes\n\n[Service]\nExecStart=/usr/bin/sudo /usr/bin/kubelet --allow-privileged=true  --cloud-provider=gce --cloud-config=/var/lib/kubernetes/gce.conf --cluster-dns=10.32.0.10   --cluster-domain=cluster.local   --container-runtime=docker   --docker=unix:///var/run/docker.sock   --kubeconfig=/var/lib/kubelet/kubeconfig   --serialize-image-pulls=false   --tls-cert-file=/var/lib/kubernetes/kubernetes.pem   --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem   --v=2\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > kube-proxy.service <<EOF\n[Unit]\n[Unit]\nDescription=Kubernetes Kube Proxy\nDocumentation=https://github.com/GoogleCloudPlatform/kubernetes\n\n[Service]\nExecStart=/usr/bin/kube-proxy   --cluster-cidr=10.200.0.0/16   --kubeconfig=/var/lib/kubelet/kubeconfig   --proxy-mode=iptables   --v=2\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\nsudo mv flannel.service /etc/systemd/system/flannel.service\nsudo mv docker.service /etc/systemd/system/docker.service\nsudo mv kubelet.service /etc/systemd/system/kubelet.service\nsudo mv kube-proxy.service /etc/systemd/system/kube-proxy.service\n\n#Start services\nsudo systemctl daemon-reload\nsudo systemctl enable flannel\nsudo systemctl enable docker\nsudo systemctl enable kubelet\nsudo systemctl enable kube-proxy\nsudo systemctl start flannel\nsudo systemctl start docker\nsudo systemctl start kubelet\nsudo systemctl start kube-proxy"
}


resource "google_compute_instance_group_manager" "igm" {
  name        = "${var.node_group}"

  base_instance_name = "${var.base_instance_name}"
  instance_template  = "${google_compute_instance_template.igm.self_link}"
  update_strategy    = "NONE"
  zone               = "${var.gce_zone}"

  target_size  = "${var.node_group_size}"
}
