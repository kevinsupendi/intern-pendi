# KUBERNETES THE HARD WAY ON BARE METAL

## Recreate using Google Compute Engine VMs

References :
[Kelseyhightower] (https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/06-kubernetes-worker.md)
[LearnKubernetes] (https://github.com/Praqma/LearnKubernetes/blob/master/kamran/Kubernetes-The-Hard-Way-on-BareMetal.md)

### Steps to do :

1. Setup network, design network, configure firewall
2. Design kubernetes architecture (H/A or not)
3. Create VMs

	There will be :
	- etcd component
	- Master component (apiserver, scheduler, controller-manager)
	- Worker component (kubelet, kube-proxy, docker)
	- Load Balancer (optional)

4. Generate certificates if necessary
5. Copy certs to all components

**etcd**

6. First ssh to etcd machine, move certs and install etcd (*Change etcd version if needed)
	
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

**Master Component**

10. 

