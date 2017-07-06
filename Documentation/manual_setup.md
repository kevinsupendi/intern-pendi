# KUBERNETES THE HARD WAY ON LINUX


## Recreate using Google Compute Engine VMs


References :


https://github.com/kelseyhightower/kubernetes-the-hard-way/tree/master/docs
https://github.com/Praqma/LearnKubernetes/blob/master/kamran/Kubernetes-The-Hard-Way-on-BareMetal.md


### Steps to do :


**Prerequisites**
Configure gce.conf to use Cloud Provider features (LoadBalancer Service and Dynamic Provisioning, Cluster autoscaler not configured in this project).
Create file gce.conf and fill the values. Create if your VM instance will be node-1 and node-2, then the prefix is node.
Create node tags for your Master and Node VM, they must have the same tag.

```
[Global]
project-id=
network-name=
node-tags=
node-instance-prefix=
```

**Initialisation**

1. Create a network for Kubernetes cluster. Configure firewall so each VM can connect to each other
2. Design kubernetes architecture (H/A or not, decide number of etcd, master and node components), in this project we use 2 etcds, 2 masters and 2 nodes
3. Create VMs (can be automated with Terraform). Master and Node must have the same tags.

	There will be :
	- 2x etcd component
	- 2x Master component (apiserver, scheduler, controller-manager)
	- 2x Node component (kubelet, kube-proxy, docker, flannel)

4. Generate certificates for HTTPS (ca.pem, kubernetes.pem, kubernetes-key.pem) [instructions](https://github.com/Praqma/LearnKubernetes/blob/master/kamran/Kubernetes-The-Hard-Way-on-BareMetal.md#configure--setup-tls-certificates-for-the-cluster)
5. Copy certs to all VMs

**etcd**

1. First ssh to etcd machine, move certs and install etcd (Change etcd version below if needed)
	
	sudo mkdir -p /etc/etcd/
	ls /etc/etcd/
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

	curl -L https://github.com/coreos/etcd/releases/download/v3.1.8/etcd-v3.1.8-linux-amd64.tar.gz -o etcd-v3.1.8-linux-amd64.tar.gz
	tar xzvf etcd-v3.1.8-linux-amd64.tar.gz 
	sudo cp etcd-v3.1.8-linux-amd64/etcd* /usr/bin/
	sudo mkdir -p /var/lib/etcd

2. Create etcd.service file for systemd

	cat > etcd.service <<"EOF"
	[Unit]
	Description=etcd
	Documentation=https://github.com/coreos

	[Service]
	ExecStart=/usr/bin/etcd --name ETCD_NAME \
	  --cert-file=/etc/etcd/kubernetes.pem \
	  --key-file=/etc/etcd/kubernetes-key.pem \
	  --peer-cert-file=/etc/etcd/kubernetes.pem \
	  --peer-key-file=/etc/etcd/kubernetes-key.pem \
	  --trusted-ca-file=/etc/etcd/ca.pem \
	  --peer-trusted-ca-file=/etc/etcd/ca.pem \
	  --initial-advertise-peer-urls https://INTERNAL_IP:2380 \
	  --listen-peer-urls https://INTERNAL_IP:2380 \
	  --listen-client-urls https://INTERNAL_IP:2379,http://127.0.0.1:2379 \
	  --advertise-client-urls https://INTERNAL_IP:2379 \
	  --initial-cluster-token etcd-cluster-0 \
	  --initial-cluster etcd1=https://10.240.0.11:2380,etcd2=https://10.240.0.12:2380 \
	  --initial-cluster-state new \
	  --data-dir=/var/lib/etcd
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	EOF

3. start service and check
4. repeat steps above for all etcd VM, etcd should be ready for now
5. Check etcd cluster with this command :

```
etcdctl --ca-file=/etc/etcd/ca.pem cluster-health
```

**Master Component**

**API Server**

1. Setup TLS certificate

	sudo mkdir -p /var/lib/kubernetes
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/

2. Download and install kubernetes latest binary

	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-apiserver
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-controller-manager
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-scheduler
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl

	chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
	sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/bin/

3. Setup Authentication and Authorization with token

	wget https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/token.csv
	
4. edit sample token
5. sudo mv token.csv /var/lib/kubernetes/
6. Create authorization policy file (for ABAC mode)
7. Create systemd file for apiserver, controller manager, scheduler, then run the service (use systemd files in ansible/roles)
8. Put them in /etc/systemd/system/
9. Put gce.conf in /var/lib/kubernetes/
10. Run this to activate services

```
sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver
sudo systemctl enable kube-controller-manager
sudo systemctl enable kube-scheduler
sudo systemctl start kube-apiserver
sudo systemctl start kube-controller-manager
sudo systemctl start kube-scheduler
```

9. Repeat steps above for other Master VM

**Worker Component**

1. Setup TLS certificate
	
	sudo mkdir -p /var/lib/kubernetes
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/

2. Install and configure flannel
3. Install docker

	wget https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz

	tar -xf docker-1.11.2.tgz

	sudo cp docker/docker* /usr/bin/

4. Setup kubelet and kube proxy (configure the parameters for systemd files, and dont forget to edit the tokens too, and delete docker bridge, and kubeconfig)

	sudo mkdir -p /opt/cni

	wget https://storage.googleapis.com/kubernetes-release/network-plugins/cni-c864f0e1ea73719b8f4582402b0847064f9883b0.tar.gz
	sudo tar -xvf cni-c864f0e1ea73719b8f4582402b0847064f9883b0.tar.gz -C /opt/cni

	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-proxy
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubelet

5. Create systemd file for flannel, docker, kubelet, kube-proxy, then run the service (use systemd files in ansible/roles)
6. Put them in /etc/systemd/system/
7. Put gce.conf in /var/lib/kubernetes/
8. Repeat steps above to other Worker VMs
9. Check Nodes with kubectl get nodes

**Testing Cluster**

1. Adding DNS add-ons
2. Smoke Test