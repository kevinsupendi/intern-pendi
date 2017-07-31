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
  - name: etcd
    image: gcr.io/google-containers/etcd-amd64:3.0.17
    binds:
     - /var:/var:rshared,rbind
     - /etc/resolv.conf:/etc/resolv.conf
     - /etc/kubernetes:/var/lib/kubernetes:rshared,rbind
    rootfsPropagation: shared
    command: ["etcd","--name","${hostname}","--cert-file=/var/lib/kubernetes/kubernetes.pem","--key-file=/var/lib/kubernetes/kubernetes-key.pem",
"--peer-cert-file=/var/lib/kubernetes/kubernetes.pem","--peer-key-file=/var/lib/kubernetes/kubernetes-key.pem","--trusted-ca-file=/var/lib/kubernetes/ca.pem",
"--peer-trusted-ca-file=/var/lib/kubernetes/ca.pem","--initial-advertise-peer-urls","https://${internal_ip}:2380","--listen-peer-urls","https://${internal_ip}:2380",
"--listen-client-urls","https://${internal_ip}:2379,http://127.0.0.1:2379","--advertise-client-urls","https://${internal_ip}:2379","--initial-cluster-token","etcd-cluster-0","--initial-cluster","${etcd_ips}",
"--initial-cluster-state","new"]
  - name: kube-apiserver
    image: gcr.io/google-containers/kube-apiserver-amd64:v${kubernetes_version}
    binds:
     - /var:/var:rshared,rbind
     - /etc/resolv.conf:/etc/resolv.conf
     - /etc/kubernetes:/var/lib/kubernetes:rshared,rbind
    rootfsPropagation: shared
    command: ["kube-apiserver","--admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,ResourceQuota,DefaultTolerationSeconds",
"--advertise-address=${internal_ip}","--allow-privileged=true","--apiserver-count=${num_master}","--authorization-mode=RBAC,ABAC","--authorization-policy-file=/var/lib/kubernetes/authorization-policy.jsonl",
"--bind-address=0.0.0.0","--cloud-provider=gce","--cloud-config=/var/lib/kubernetes/gce.conf","--client-ca-file=/var/lib/kubernetes/ca.pem","--enable-swagger-ui=true",
"--etcd-quorum-read=true","--etcd-cafile=/var/lib/kubernetes/ca.pem","--etcd-servers=${etcd_endpoints}","--service-account-key-file=/var/lib/kubernetes/kubernetes-key.pem",
"--service-cluster-ip-range=${svc_cluster_ip_range}","--service-node-port-range=${svc_node_port_range}","--tls-cert-file=/var/lib/kubernetes/kubernetes.pem","--tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem",
"--token-auth-file=/var/lib/kubernetes/token.csv","--v=2"]
  - name: kube-controller-manager
    binds:
     - /var:/var:rshared,rbind
     - /etc/resolv.conf:/etc/resolv.conf
     - /etc/ssl:/etc/ssl:rshared,rbind
     - /etc/kubernetes:/var/lib/kubernetes:rshared,rbind
    rootfsPropagation: shared
    image: gcr.io/google-containers/kube-controller-manager-amd64:v${kubernetes_version}
    command: ["kube-controller-manager","--allocate-node-cidrs=true","--cluster-cidr=${cluster_cidr}","--cluster-name=kubernetes","--cloud-provider=gce","--cloud-config=/var/lib/kubernetes/gce.conf"
,"--leader-elect=true","--master=http://127.0.0.1:8080","--root-ca-file=/var/lib/kubernetes/ca.pem","--service-account-private-key-file=/var/lib/kubernetes/kubernetes-key.pem"
,"--service-cluster-ip-range=${svc_cluster_ip_range}","--v=2"]
  - name: kube-scheduler
    binds:
     - /var:/var:rshared,rbind
     - /etc/resolv.conf:/etc/resolv.conf
     - /etc/kubernetes:/var/lib/kubernetes:rshared,rbind
    rootfsPropagation: shared
    image: gcr.io/google-containers/kube-scheduler-amd64:v${kubernetes_version}
    command: ["kube-scheduler","--leader-elect=true","--master=http://127.0.0.1:8080","--v=2"]
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
  - path: etc/kubernetes/token.csv
    source: modules/compute/temp/token.csv
  - path: etc/kubernetes/authorization-policy.jsonl
    source: modules/compute/files/authorization-policy.jsonl
  - {path: etc/cni, directory: true}
  - {path: opt/cni, directory: true}