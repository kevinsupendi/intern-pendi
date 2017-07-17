variable "project_id" {}

variable "net_name" {}

variable "gce_zone" {}

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


resource "google_compute_instance" "master" {
  count = "${var.num_master}"
  name         = "${var.master_name}-${count.index + 1}"
  machine_type = "${var.master_type}"
  zone         = "${var.gce_zone}"

  tags = "${var.tags}"

  disk {
    image = "${var.gce_image}"
    size = "${var.master_disk_size}"
  }

  network_interface {
    subnetwork = "${var.subnet}"
    access_config {
      // Ephemeral IP
    }
  }
 
  can_ip_forward = "${var.can_ip_forward}"
  
  service_account {
    scopes = "${var.svc_account_scopes}"
  }

  metadata {
    block-project-ssh-keys="${var.block_project_ssh_keys}"
    ssh-keys = "pendi:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = "#! /bin/bash\n\n#Generate certificates\n\necho 'capem' > ca.pem\necho 'kubernetespem' > kubernetes.pem\necho 'kuberneteskeypem' > kubernetes-key.pem\n\n\nmkdir /etc/etcd/\ncp ca.pem /etc/etcd/ca.pem\ncp kubernetes.pem /etc/etcd/kubernetes.pem\ncp kubernetes-key.pem /etc/etcd/kubernetes-key.pem\n\n#Install etcd\nwget https://github.com/coreos/etcd/releases/download/v3.1.8/etcd-v3.1.8-linux-amd64.tar.gz\ntar xzvf etcd-v3.1.8-linux-amd64.tar.gz \nsudo cp etcd-v3.1.8-linux-amd64/etcd* /usr/bin/\nsudo mkdir -p /var/lib/etcd\n\nmkdir /var/lib/etcd/\n\n#Create etcd systemd\n\ncat > etcd.service <<\"EOF\"\n[Unit]\nDescription=etcd\nDocumentation=https://github.com/coreos\n\n[Service]\nExecStart=/usr/bin/etcd --name etcd-1 \\\n  --cert-file=/etc/etcd/kubernetes.pem \\\n  --key-file=/etc/etcd/kubernetes-key.pem \\\n  --peer-cert-file=/etc/etcd/kubernetes.pem \\\n  --peer-key-file=/etc/etcd/kubernetes-key.pem \\\n  --trusted-ca-file=/etc/etcd/ca.pem \\\n  --peer-trusted-ca-file=/etc/etcd/ca.pem \\\n  --initial-advertise-peer-urls https://10.240.16.2:2380 \\\n  --listen-peer-urls https://10.240.16.2:2380 \\\n  --listen-client-urls https://10.240.16.2:2379,http://127.0.0.1:2379 \\\n  --advertise-client-urls https://10.240.16.2:2379 \\\n  --initial-cluster-token etcd-cluster-0 \\\n  --initial-cluster etcd-1=https://10.240.16.2:2380 \\\n  --initial-cluster-state new \\\n  --data-dir=/var/lib/etcd\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\nsudo mv etcd.service /etc/systemd/system/etcd.service\n\n#Start services\nsudo systemctl daemon-reload\nsudo systemctl enable etcd\nsudo systemctl start etcd\n\netcdctl --ca-file=/etc/etcd/ca.pem --cert-file=/etc/etcd/kubernetes.pem --key-file=/etc/etcd/kubernetes-key.pem cluster-health\netcdctl --ca-file=/etc/etcd/ca.pem --cert-file=/etc/etcd/kubernetes.pem --key-file=/etc/etcd/kubernetes-key.pem set /coreos.com/network/config '{ \"Network\": \"10.200.0.0/16\", \"Backend\": {\"Type\": \"vxlan\"}}'\n\n\nmkdir /var/lib/kubernetes\nmv ca.pem /var/lib/kubernetes/ca.pem\nmv kubernetes.pem /var/lib/kubernetes/kubernetes.pem\nmv kubernetes-key.pem /var/lib/kubernetes/kubernetes-key.pem\n\n#Create gce.conf\ncat > gce.conf <<EOF\n[Global]\nproject-id=intern-kevin\nnetwork-name=kubenet\nnode-tags=node\nnode-instance-prefix=node-group\nEOF\n\nsudo mv gce.conf /var/lib/kubernetes/gce.conf\n\n#Create token.csv\ncat > token.csv <<EOF\nchangeme,scheduler,scheduler\nchangeme,kubelet,kubelet\nchangeme,controller,controller\nEOF\n\nmv token.csv /var/lib/kubernetes/token.csv\n\n#Create kubeconfig\ncat > kubeconfig <<EOF\napiVersion: v1\nkind: Config\nclusters:\n- cluster:\n    certificate-authority: /var/lib/kubernetes/ca.pem\n    server: https://10.240.16.2:6443\n  name: kubernetes\ncontexts:\n- context:\n    cluster: kubernetes\n    user: kubelet\n  name: kubelet\ncurrent-context: kubelet\nusers:\n- name: kubelet\n  user:\n    token: changeme\nEOF\n\nsudo mv kubeconfig /var/lib/kubernetes/kubeconfig\n\n#Install Kubernetes master binary\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-apiserver\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-controller-manager\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-scheduler\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl\n\nchmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl\nsudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/bin/\n\n#Create master systemd\ncat > kube-apiserver.service <<EOF\n[Unit]\nDescription=Kubernetes API Server\nDocumentation=https://github.com/GoogleCloudPlatform/kubernetes\n\n[Service]\nExecStart=/usr/bin/kube-apiserver \\\n  --admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,ResourceQuota,DefaultTolerationSeconds \\\n  --advertise-address={{ internal_ip }} \\\n  --allow-privileged=true \\\n  --apiserver-count={{ master_ips | length }} \\\n  --authorization-mode=RBAC,ABAC \\\n  --authorization-policy-file=/var/lib/kubernetes/authorization-policy.jsonl \\\n  --bind-address=0.0.0.0 \\\n  --cloud-provider=gce \\\n  --cloud-config=/var/lib/kubernetes/gce.conf \\\n  --enable-swagger-ui=true \\\n  --etcd-cafile=/var/lib/kubernetes/ca.pem \\\n  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \\\n  --etcd-servers={{ etcd_servers_ip }} \\\n  --service-account-key-file=/var/lib/kubernetes/kubernetes-key.pem \\\n  --service-cluster-ip-range=10.32.0.0/24 \\\n  --service-node-port-range=30000-32767 \\\n  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \\\n  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \\\n  --token-auth-file=/var/lib/kubernetes/token.csv \\\n  --v=2\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > kube-controller-manager.service <<EOF\n[Unit]\nDescription=Kubernetes Controller Manager\nDocumentation=https://github.com/GoogleCloudPlatform/kubernetes\n\n[Service]\nExecStart=/usr/bin/kube-controller-manager \\\n  --allocate-node-cidrs=true \\\n  --cluster-cidr=10.200.0.0/16 \\\n  --cluster-name=kubernetes \\\n  --cloud-provider=gce \\\n  --cloud-config=/var/lib/kubernetes/gce.conf \\\n  --leader-elect=true \\\n  --kubeconfig=/var/lib/kubernetes/kubeconfig \\\n  --root-ca-file=/var/lib/kubernetes/ca.pem \\\n  --service-account-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \\\n  --service-cluster-ip-range=10.32.0.0/24 \\\n  --v=2\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > kube-scheduler.service <<EOF\n[Unit]\nDescription=Kubernetes Scheduler\nDocumentation=https://github.com/GoogleCloudPlatform/kubernetes\n\n[Service]\nExecStart=/usr/bin/kube-scheduler \\\n  --leader-elect=true \\\n  --kubeconfig=/var/lib/kubernetes/kubeconfig \\\n  --v=2\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\nmv kube-apiserver.service /etc/systemd/system/kube-apiserver.service\nmv kube-controller-manager.service /etc/systemd/system/kube-controller-manager.service\nmv kube-scheduler.service /etc/systemd/system/kube-scheduler.service\n\n#Start services\nsudo systemctl daemon-reload\nsudo systemctl enable kube-apiserver\nsudo systemctl enable kube-controller-manager\nsudo systemctl enable kube-scheduler\nsudo systemctl start kube-apiserver\nsudo systemctl start kube-controller-manager\nsudo systemctl start kube-scheduler\n\n\n#Install Flanneld\nwget https://github.com/coreos/flannel/releases/download/v0.7.0/flannel-v0.7.0-linux-amd64.tar.gz\ntar -xf flannel-v0.7.0-linux-amd64.tar.gz\nchmod +x flanneld\nsudo mv flanneld /usr/bin/flanneld\n\n#Install Docker\nwget https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz\ntar -xf docker-1.11.2.tgz\nsudo cp docker/docker* /usr/bin/\n\n\n#Install Kubelet\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubelet\nchmod +x kubelet\nsudo mv kubelet /usr/bin/kubelet\n\n#Create kubeconfig\ncat > kubeconfig <<EOF\napiVersion: v1\nkind: Config\nclusters:\n- cluster:\n    certificate-authority: /var/lib/kubernetes/ca.pem\n    server: https://10.240.16.2:6443\n  name: kubernetes\ncontexts:\n- context:\n    cluster: kubernetes\n    user: kubelet\n  name: kubelet\ncurrent-context: kubelet\nusers:\n- name: kubelet\n  user:\n    token: changeme\nEOF\n\nsudo mkdir /var/lib/kubelet\nsudo mv kubeconfig /var/lib/kubelet/kubeconfig\n\n#Install Kube-proxy\nwget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-proxy\nchmod +x kube-proxy\nsudo mv kube-proxy /usr/bin/kube-proxy\n\n#Create systemd files\n\ncat > flannel.service <<EOF\n[Unit]\nDescription=Flannel\nDocumentation=https://github.com/coreos/flannel\n\n[Service]\nExecStart=/usr/bin/flanneld --etcd-endpoints=https://10.240.16.2:2379 \\\\\n  --etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem \\\\\n  --etcd-certfile=/var/lib/kubernetes/kubernetes.pem \\\\\n  --etcd-cafile=/var/lib/kubernetes/ca.pem \\\\\n  --ip-masq=true\n\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > docker.service <<EOF\n[Unit]\nDescription=Docker Application Container Engine\nDocumentation=http://docs.docker.io\nAfter=flannel.service\nRequires=flannel.service\n\n[Service]\nEnvironmentFile=/run/flannel/subnet.env\nExecStart=/usr/bin/docker daemon --bip=\\$${FLANNEL_SUBNET} --mtu=\\$${FLANNEL_MTU}  --iptables=false   --ip-masq=false   --host=unix:///var/run/docker.sock   --log-level=error   --storage-driver=overlay\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > kubelet.service <<EOF\n[Unit]\nDescription=Kubernetes Kubelet\nDocumentation=https://github.com/GoogleCloudPlatform/kubernetes\n\n[Service]\nExecStart=/usr/bin/sudo /usr/bin/kubelet --allow-privileged=true  --cloud-provider=gce --cloud-config=/var/lib/kubernetes/gce.conf --cluster-dns=10.32.0.10   --cluster-domain=cluster.local   --container-runtime=docker   --docker=unix:///var/run/docker.sock   --kubeconfig=/var/lib/kubelet/kubeconfig   --serialize-image-pulls=false   --tls-cert-file=/var/lib/kubernetes/kubernetes.pem   --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem   --v=2\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\ncat > kube-proxy.service <<EOF\n[Unit]\n[Unit]\nDescription=Kubernetes Kube Proxy\nDocumentation=https://github.com/GoogleCloudPlatform/kubernetes\n\n[Service]\nExecStart=/usr/bin/kube-proxy   --cluster-cidr=10.200.0.0/16   --kubeconfig=/var/lib/kubelet/kubeconfig   --proxy-mode=iptables   --v=2\nRestart=on-failure\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\nsudo mv flannel.service /etc/systemd/system/flannel.service\nsudo mv docker.service /etc/systemd/system/docker.service\nsudo mv kubelet.service /etc/systemd/system/kubelet.service\nsudo mv kube-proxy.service /etc/systemd/system/kube-proxy.service\n\n#Start services\nsudo systemctl daemon-reload\nsudo systemctl enable flannel\nsudo systemctl enable docker\nsudo systemctl enable kubelet\nsudo systemctl enable kube-proxy\nsudo systemctl start flannel\nsudo systemctl start docker\nsudo systemctl start kubelet\nsudo systemctl start kube-proxy"
}