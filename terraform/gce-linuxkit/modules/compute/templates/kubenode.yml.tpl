kernel:
  image: linuxkit/kernel:4.9.39
  cmdline: "console=tty0 console=ttyS0"
init:
  - linuxkit/init:4dcee04c04c900a5796dc719f8d16fea7e771059
  - linuxkit/runc:f5960b83a8766ae083efc744fa63dbf877450e4f
  - linuxkit/containerd:acd23f7c020e09799e03331e781f35965e19981f
  - linuxkit/ca-certificates:67acf038c44bb191ebb704ec7bb39a1524052cdf
onboot:
  - name: sysctl
    image: linuxkit/sysctl:d1a43c7c91e92374766f962dc8534cf9508756b0
  - name: sysfs
    image: linuxkit/sysfs:006a65b30cfdd9d751d7ab042fde7eca2c3bc9dc
  - name: binfmt
    image: linuxkit/binfmt:0bde4ebd422099f45c5ee03217413523ad2223e5
  - name: dhcpcd
    image: linuxkit/dhcpcd:17423c1ccced74e3c005fd80486e8177841fe02b
    command: ["/sbin/dhcpcd", "--nobackground", "-f", "/dhcpcd.conf", "-1"]
  - name: metadata
    image: linuxkit/metadata:f5d4299909b159db35f72547e4ae70bd76c42c6c
  - name: format
    image: linuxkit/format:efafddf9bc6165b5efaf09c532c15a1100a10e61
  - name: mounts
    image: linuxkit/mount:54990a6a69cb3ead4da8a9c1f0b651e27aea8d3f
    command: ["/usr/bin/mountie", "/var/lib/"]
services:
  - name: getty
    image: linuxkit/getty:894eef1e5f62f3bc31de8ffaff2b6c0e093c4595
    env:
     - INSECURE=true
  - name: rngd
    image: linuxkit/rngd:1516d5d70683a5d925fe475eb1b6164a2f67ac3b
  - name: ntpd
    image: linuxkit/openntpd:2874b66c9fa51fa5b4d11c8b50441eb94ee22a5a
  - name: sshd
    image: linuxkit/sshd:5dc5c3c4470c85f6c89f0e26b9d477ae4ff85a3c
    binds:
     - /var/config/ssh/authorized_keys:/root/.ssh/authorized_keys
  - name: flannel
    binds:
     - /var:/var:rshared,rbind
     - /etc/resolv.conf:/etc/resolv.conf
     - /etc/kubernetes:/var/lib/kubernetes:rshared,rbind
    rootfsPropagation: shared
    image: quay.io/coreos/flannel:v0.7.0-amd64
    command: ["/opt/bin/flanneld","--etcd-endpoints=https://10.148.0.4:2379","--etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem","--etcd-certfile=/var/lib/kubernetes/kubernetes.pem"
,"--etcd-cafile=/var/lib/kubernetes/ca.pem","--ip-masq=true"]
  - name: docker
    image: docker:17.06.0-ce-dind
    capabilities:
     - all
    pid: host
    mounts:
     - type: cgroup
       options: ["rw","nosuid","noexec","nodev","relatime"]
    binds:
     - /dev:/dev
     - /etc/resolv.conf:/etc/resolv.conf
     - /lib/modules:/lib/modules
     - /var:/var:rshared,rbind
     - /etc/cni:/etc/cni:rshared,rbind
     - /opt/cni:/opt/cni:rshared,rbind
    rootfsPropagation: shared
    command: ["/usr/local/bin/docker-init", "/usr/local/bin/dockerd","--","--iptables=false","--ip-masq=false","--host=unix:///var/run/docker.sock","--log-level=error","--storage-driver=overlay"]
  - name: kubelet
    image: gcr.io/google-containers/hyperkube-amd64:v${kubernetes_version}
    mounts:
     - type: cgroup
       options: ["rw","nosuid","noexec","nodev","relatime"]
    binds:
     - /var:/var:rshared,rbind
     - /etc/resolv.conf:/etc/resolv.conf
     - /etc/kubernetes:/var/lib/kubernetes:rshared,rbind
    capabilities:
     - all
    rootfsPropagation: shared
    command: ["kubelet","--allow-privileged=true","--require-kubeconfig=true","--register-node=true","--cloud-provider=gce","--cloud-config=/var/lib/kubernetes/gce.conf"
,"--container-runtime=docker","--cluster-domain=${cluster_domain}","--cluster-dns=${cluster_dns}","--docker=unix:///var/run/docker.sock","--kubeconfig=/var/lib/kubernetes/kubeconfig"
,"--serialize-image-pulls=false","--v=2"]
  - name: kube-proxy
    image: gcr.io/google-containers/kube-proxy:v${kubernetes_version}
    binds:
     - /var:/var:rshared,rbind
     - /etc/resolv.conf:/etc/resolv.conf
     - /etc/kubernetes:/var/lib/kubernetes:rshared,rbind
    rootfsPropagation: shared
    capabilities:
     - all
    command: ["kube-proxy","--cluster-cidr=${cluster_cidr}","--kubeconfig=/var/lib/kubernetes/kubeconfig","--proxy-mode=iptables","--v=2"]
files:
  - path: etc/kubernetes
    directory: true
    mode: "0777"
  - path: etc/kubernetes/ca.pem
    source: modules/compute/temp/ca.pem
  - path: etc/kubernetes/kubernetes.pem
    source: modules/compute/temp/kubernetes.pem
  - path: etc/kubernetes/kubernetes-key.pem
    source: modules/compute/temp/kubernetes-key.pem
  - path: etc/kubernetes/gce.conf
    source: modules/compute/temp/gce.conf
  - path: etc/kubernetes/kubeconfig
    source: modules/compute/temp/kubeconfig
  - {path: etc/cni, directory: true}
  - {path: opt/cni, directory: true}