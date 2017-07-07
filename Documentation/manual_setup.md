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

        Here are the VMs I am creating:

        - etcd-1		10.240.0.11/24
        - etcd-2		10.240.0.12/24
        - master-1		10.240.0.21/24
        - master-2		10.240.0.22/24
        - node-1		10.240.0.31/24
        - node-2		10.240.0.32/24

4. Generate certificates for HTTPS (ca.pem, kubernetes.pem, kubernetes-key.pem) [instructions](https://github.com/Praqma/LearnKubernetes/blob/master/kamran/Kubernetes-The-Hard-Way-on-BareMetal.md#configure--setup-tls-certificates-for-the-cluster)
5. Copy certs to all VMs

**etcd**

1. First ssh to etcd machine, move certs and install etcd (Change etcd version below if needed)
	
	```
	sudo mkdir -p /etc/etcd/
	ls /etc/etcd/
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

	curl -L https://github.com/coreos/etcd/releases/download/v3.1.8/etcd-v3.1.8-linux-amd64.tar.gz -o etcd-v3.1.8-linux-amd64.tar.gz
	tar xzvf etcd-v3.1.8-linux-amd64.tar.gz 
	sudo cp etcd-v3.1.8-linux-amd64/etcd* /usr/bin/
	sudo mkdir -p /var/lib/etcd
	```

2. Create etcd.service file for systemd

	```
	cat > etcd.service <<"EOF"
	[Unit]
	Description=etcd
	Documentation=https://github.com/coreos

	[Service]
	ExecStart=/usr/bin/etcd --name etcd-1 \
	  --cert-file=/etc/etcd/kubernetes.pem \
	  --key-file=/etc/etcd/kubernetes-key.pem \
	  --peer-cert-file=/etc/etcd/kubernetes.pem \
	  --peer-key-file=/etc/etcd/kubernetes-key.pem \
	  --trusted-ca-file=/etc/etcd/ca.pem \
	  --peer-trusted-ca-file=/etc/etcd/ca.pem \
	  --initial-advertise-peer-urls https://10.240.0.11:2380 \
	  --listen-peer-urls https://10.240.0.11:2380 \
	  --listen-client-urls https://10.240.0.11:2379,http://127.0.0.1:2379 \
	  --advertise-client-urls https://10.240.0.11:2379 \
	  --initial-cluster-token etcd-cluster-0 \
	  --initial-cluster etcd-1=https://10.240.0.11:2380,etcd-2=https://10.240.0.12:2380 \
	  --initial-cluster-state new \
	  --data-dir=/var/lib/etcd
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	EOF
	```

3. start service and check
4. repeat steps above for all etcd VM, etcd should be ready for now
5. Check etcd cluster with this command :

	```
	etcdctl --ca-file=/etc/etcd/ca.pem cluster-health
	```
6. Create flannel configuration in etcd

	```
	etcdctl --ca-file=/etc/etcd/ca.pem --cert-file=/etc/etcd/kubernetes.pem --key-file=/etc/etcd/kubernetes-key.pem set /coreos.com/network/config '{ "Network": "10.200.0.0/16", "Backend": {"Type": "vxlan"}}'
	```

**Master Component**

**API Server**

1. Setup TLS certificate

	```
	sudo mkdir -p /var/lib/kubernetes
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/
	```

2. Download and install kubernetes latest binary

	```
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-apiserver
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-controller-manager
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-scheduler
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl

	chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
	sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/bin/
	```

3. Setup Authentication and Authorization with token

	```
	wget https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/token.csv
	```

4. edit sample token
5. sudo mv token.csv /var/lib/kubernetes/
6. Create authorization policy file (for ABAC mode), example in ansible/roles/kube-apiserver/
7. Create kubeconfig and put it in /var/lib/kubernetes/, you can find the example in ansible/roles/kube-scheduler/templates/kubeconfig.j2
8. Create systemd file for apiserver, controller manager, scheduler

	kube-apiserver.service
	
	```
	[Unit]
	Description=Kubernetes API Server
	Documentation=https://github.com/GoogleCloudPlatform/kubernetes
	
	[Service]
	ExecStart=/usr/bin/kube-apiserver \
	  --admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,ResourceQuota,DefaultTolerationSeconds \
	  --advertise-address=10.240.0.21 \
	  --allow-privileged=true \
	  --apiserver-count=2 \
	  --authorization-mode=RBAC,ABAC \
	  --authorization-policy-file=/var/lib/kubernetes/authorization-policy.jsonl \
	  --bind-address=0.0.0.0 \
	  --cloud-provider=gce \
	  --cloud-config=/var/lib/kubernetes/gce.conf \
	  --enable-swagger-ui=true \
	  --etcd-cafile=/var/lib/kubernetes/ca.pem \
	  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \
	  --etcd-servers=https://10.240.0.11:2380,https://10.240.0.12:2380 \
	  --service-account-key-file=/var/lib/kubernetes/kubernetes-key.pem \
	  --service-cluster-ip-range=10.32.0.0/24 \
	  --service-node-port-range=30000-32767 \
	  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \
	  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
	  --token-auth-file=/var/lib/kubernetes/token.csv \
	  --v=2
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	```
	
	kube-controller-manager.service
	
	```
	[Unit]
	Description=Kubernetes Controller Manager
	Documentation=https://github.com/GoogleCloudPlatform/kubernetes
	
	[Service]
	ExecStart=/usr/bin/kube-controller-manager \
	  --allocate-node-cidrs=true \
	  --cluster-cidr=10.200.0.0/16 \
	  --cluster-name=kubernetes \
	  --cloud-provider=gce \
	  --cloud-config=/var/lib/kubernetes/gce.conf \
	  --leader-elect=true \
	  --kubeconfig=/var/lib/kubernetes/kubeconfig \
	  --root-ca-file=/var/lib/kubernetes/ca.pem \
	  --service-account-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
	  --service-cluster-ip-range=10.32.0.0/24 \
	  --v=2
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	```
	
	kube-scheduler.service
	
	```
	[Unit]
	Description=Kubernetes Scheduler
	Documentation=https://github.com/GoogleCloudPlatform/kubernetes
	
	[Service]
	ExecStart=/usr/bin/kube-scheduler \
	  --leader-elect=true \
	  --kubeconfig=/var/lib/kubernetes/kubeconfig \
	  --v=2
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	```

9. Put them in /etc/systemd/system/
10. Put gce.conf in /var/lib/kubernetes/
11. Run this to activate services

	```
	sudo systemctl daemon-reload
	sudo systemctl enable kube-apiserver
	sudo systemctl enable kube-controller-manager
	sudo systemctl enable kube-scheduler
	sudo systemctl start kube-apiserver
	sudo systemctl start kube-controller-manager
	sudo systemctl start kube-scheduler
	```

12. Repeat steps above for other Master VM

**Worker Component**

1. Setup TLS certificate
	
	```
	sudo mkdir -p /var/lib/kubernetes
	sudo mv ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/
	```

2. Install and configure flannel

	```
	wget https://github.com/coreos/flannel/releases/download/v0.7.0/flannel-v0.7.0-linux-amd64.tar.gz
	tar -xf flannel-v0.7.0-linux-amd64.tar.gz
	chmod +x flanneld
	sudo mv flanneld /usr/bin/flanneld
	```

3. Install docker

	```
	wget https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz
	tar -xf docker-1.11.2.tgz
	sudo cp docker/docker* /usr/bin/
	```

4. Setup kubelet and kube proxy

	```
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-proxy
	wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubelet
	```
5. Create kubeconfig and put it in /var/lib/kubelet/, you can find the example in ansible/roles/kubelet/templates/kubeconfig.j2
6. Create systemd file for flannel, docker, kubelet, kube-proxy, then run the service (use systemd files in ansible/roles)

	flannel.service
	```
	[Unit]
	Description=Flannel
	Documentation=https://github.com/coreos/flannel
	
	[Service]
	ExecStart=/usr/bin/flanneld --etcd-endpoints=https://10.240.0.11:2380,https://10.240.0.12:2380 \
	  --etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem \
	  --etcd-certfile=/var/lib/kubernetes/kubernetes.pem \
	  --etcd-cafile=/var/lib/kubernetes/ca.pem \
	  --ip-masq=true
	
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	```

	docker.service

	```
	[Unit]
	Description=Docker Application Container Engine
	Documentation=http://docs.docker.io
	After=flannel.service
	Requires=flannel.service
	
	[Service]
	EnvironmentFile=/run/flannel/subnet.env
	ExecStart=/usr/bin/docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}  --iptables=false   --ip-masq=false   --host=unix:///var/run/docker.sock   --log-level=error   --storage-driver=overlay
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	```

	kubelet.service
	
	```
	[Unit]
	Description=Kubernetes Kubelet
	Documentation=https://github.com/GoogleCloudPlatform/kubernetes
	
	[Service]
	ExecStart=/usr/bin/sudo /usr/bin/kubelet --allow-privileged=true   --api-servers=https://10.240.0.21:6443,https://10.240.0.22:6443  --cloud-provider=gce --cloud-config=/var/lib/kubernetes/gce.conf --cluster-dns=10.32.0.10   --cluster-domain=cluster.local   --container-runtime=docker   --docker=unix:///var/run/docker.sock   --kubeconfig=/var/lib/kubelet/kubeconfig   --serialize-image-pulls=false   --tls-cert-file=/var/lib/kubernetes/kubernetes.pem   --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem   --v=2
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	```
	
	kube-proxy.service
	
	```
	[Unit]
	Description=Kubernetes Kube Proxy
	Documentation=https://github.com/GoogleCloudPlatform/kubernetes
	
	[Service]
	ExecStart=/usr/bin/kube-proxy   --cluster-cidr=10.200.0.0/16   --kubeconfig=/var/lib/kubelet/kubeconfig   --proxy-mode=iptables   --v=2
	Restart=on-failure
	RestartSec=5
	
	[Install]
	WantedBy=multi-user.target
	```

7. Put them in /etc/systemd/system/
8. Put gce.conf in /var/lib/kubernetes/
9. Run this to activate services

	```
	sudo systemctl daemon-reload
	sudo systemctl enable flannel
	sudo systemctl enable docker
	sudo systemctl enable kubelet
	sudo systemctl enable kube-proxy
	sudo systemctl start flannel
	sudo systemctl start docker
	sudo systemctl start kubelet
	sudo systemctl start kube-proxy
	```
10. Repeat steps above to other Worker VMs
11. Check Nodes with kubectl get nodes

**Testing Cluster**
Even though your nodes are ready, you should test if your Service and Deployment can work well.

1. Run this command to deploy nginx application

    ```
    kubectl run nginx --image=nginx --port=80 --replicas=3
    ```

2. Check the pods' statuses

    ```
    kubectl get pods -o wide
    ```

    Make sure they are running

3. Expose the Service with type NodePort

    ```
    kubectl expose deployment nginx --type NodePort
    ```

4. Get the Service Port

    ```
    kubectl get svc
    ```

    You should see Port with value 80:30000ish

5. Test the nginx service using cURL or web browser :

    ```
    curl http://${NODE_PUBLIC_IP}:${NODE_PORT}
    ```
