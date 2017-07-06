# KUBERNETES THE HARD WAY ON LINUX


## Recreate using Google Compute Engine VMs


References :


https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/06-kubernetes-worker.md
https://github.com/Praqma/LearnKubernetes/blob/master/kamran/Kubernetes-The-Hard-Way-on-BareMetal.md


### Steps to do :

1. Setup network, design network, configure firewall (can be automated with Terraform)
2. Design kubernetes architecture (H/A or not, decide number of etcd, master and node components)
3. Create VMs (can be automated with Terraform)

	There will be :
	- etcd component
	- Master component (apiserver, scheduler, controller-manager)
	- Node component (kubelet, kube-proxy, docker)

4. Generate certificates for HTTPS
5. Copy certs to all components

**etcd**

6. First ssh to etcd machine, move certs and install etcd (Change etcd version below if needed)
	
	sudo mkdir -p /etc/etcd/
	ls /etc/etcd/
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

	curl -L https://github.com/coreos/etcd/releases/download/v3.1.8/etcd-v3.1.8-linux-amd64.tar.gz -o etcd-v3.1.8-linux-amd64.tar.gz
	tar xzvf etcd-v3.1.8-linux-amd64.tar.gz 
	sudo cp etcd-v3.1.8-linux-amd64/etcd* /usr/bin/
	sudo mkdir -p /var/lib/etcd

7. Create etcd.service file for systemd

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

8. start service and check
9. repeat step 6-8 for all etcd VM, etcd should be ready for now

**Configure Cloud provider : gce.conf**
(later)

**Master Component**

**API Server**

10. Setup TLS certificate

	sudo mkdir -p /var/lib/kubernetes
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/

11. Download and install kubernetes latest binary

	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-apiserver
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-controller-manager
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-scheduler
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl

	chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
	sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/bin/

12. Setup Authentication and Authorization with token

	wget https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/token.csv
	
13. edit sample token
14. sudo mv token.csv /var/lib/kubernetes/
15. Create authorization policy file (for ABAC mode)
16. Create systemd file for apiserver, controller manager, scheduler, then run the service
17. Repeat step 10-16 for other Master VM

**Worker Component**

18. Setup TLS certificate
	
	sudo mkdir -p /var/lib/kubernetes
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/

18. Install and configure flannel
20. Install docker

	wget https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz

	tar -xf docker-1.11.2.tgz

	sudo cp docker/docker* /usr/bin/

21. Setup kubelet and kube proxy (configure the parameters for systemd files, and dont forget to edit the tokens too, and delete docker bridge, and kubeconfig)

	sudo mkdir -p /opt/cni

	wget https://storage.googleapis.com/kubernetes-release/network-plugins/cni-c864f0e1ea73719b8f4582402b0847064f9883b0.tar.gz
	sudo tar -xvf cni-c864f0e1ea73719b8f4582402b0847064f9883b0.tar.gz -C /opt/cni

	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-proxy
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubelet

22. Repeat step 18-21 to other Worker VMs
23. Check Nodes with kubectl get nodes

**Testing Cluster**

24. Adding DNS add-ons
25. Smoke Test