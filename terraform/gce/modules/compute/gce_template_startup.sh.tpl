#! /bin/bash

#Generate certificates

echo '-----BEGIN CERTIFICATE-----
MIIDuDCCAqCgAwIBAgIUOGUc6zD7dcmfEh1ES8NoRC/bjT0wDQYJKoZIhvcNAQEL
BQAwYjELMAkGA1UEBhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8x
EzARBgNVBAoTCkt1YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJl
cm5ldGVzMB4XDTE3MDcxODA2MTIwMFoXDTIyMDcxNzA2MTIwMFowYjELMAkGA1UE
BhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8xEzARBgNVBAoTCkt1
YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJlcm5ldGVzMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwX0v+9D5Uua2zH5+OCk/TP96oRuB
kclRxFFrRiPblSFsh3iEMzPYjyMXyXotWxGX8cTRSMHn+jjqOq5TPU+LPnNTmScS
6BnkXlAHBOtNqlqH9bmazfLjtdY1bb7wjB+392aKIC41KFjzJ/yhP9bp63wGeJBE
NCToj8/SrFNNr5aI3/MpBtjafWuh+R0jlzaH4elCKbtpuT+CXDL2KdepECNaVKOj
5VsZcV5uIR13erlm9V9i4eES9WvYizaRVAz6AXOy/EsHi9v+rvWDfDbg7gF/TkqY
j95xY1OW7JSpwEZYYLkVW0atQBOCmLqwusq9HBHAcDAQZ1/N9bSUPMNYBQIDAQAB
o2YwZDAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBAjAdBgNVHQ4E
FgQUyURngcjghnv3xL+JMA1FndkpHt8wHwYDVR0jBBgwFoAUyURngcjghnv3xL+J
MA1FndkpHt8wDQYJKoZIhvcNAQELBQADggEBAFje9hOgcBUVy0Jn51tCg4gQKPMd
FxTVJ0DShVo+dTDOB+Bne83FK7TWUXfHegw67n+EFFH4BZROnLJAnzGZp9XLXkFA
gNKLPNSnEigZJHpnbR8gc8FKr2xHE3be1x7XZfVoEGd4QMnph400G3rGmjHg3NR1
Bh+CdNJ5xswUpY6Rxirmlk4eOFx08lqtDzE7yZ9lJ0jX8qKIEgCgGPFSG6YSYcwC
KFKqdxjUD6PvoQk202o75EU2ajlw/yn5lGCDOKQZxu//kMNwUfEGxYMseQrEj98e
jCrUy6zDBVKisD/sGvExf0fvmLL15WhQ1xn2w5SzdnobJwa5KRQXBYRqCGE=
-----END CERTIFICATE-----
' > ca.pem
echo '-----BEGIN CERTIFICATE-----
MIIELDCCAxSgAwIBAgIUMzvyh7yeNljIpRVI/E0JOdbxd+AwDQYJKoZIhvcNAQEL
BQAwYjELMAkGA1UEBhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8x
EzARBgNVBAoTCkt1YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJl
cm5ldGVzMB4XDTE3MDcxODA2MTIwMFoXDTE4MDcxODA2MTIwMFowdjELMAkGA1UE
BhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8xEzARBgNVBAoTCkt1
YmVybmV0ZXMxEDAOBgNVBAsTB0NsdXN0ZXIxIjAgBgNVBAMTGSouYy5pbnRlcm4t
a2V2aW4uaW50ZXJuYWwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9
pEPYgOfPeZpsJy+BHbN5TPGwgAHTLlr9gKemrRgH6dYd9qfJIuEmJcbk/4BR52ws
Zsk3vbake7IPXQ5sV6PipmE/OKrZhf/6t8zSuXFeg7zDx6CBmj7MPaqt07pVIY7Y
sYl67avvrFQoJveMHDBLXyTQ49FDlD/E0kDlfZAQ4pRpJgd4gIcOqaVMv5NNA8Bz
RF34kzGa0Higd7jc2rOWCjmbeeFdWj0/KId2pIIf84d1VaK7v6qdkM7LxqbDsRti
fBlfX3xnOvucuVgpk24J7CHggn7bV7l+tijLD2cjW484l/4EFfalN9TxtlpGOSk2
PdrniieFAZ5Etv9ScJUFAgMBAAGjgcUwgcIwDgYDVR0PAQH/BAQDAgWgMB0GA1Ud
JQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB0GA1UdDgQW
BBQslz2GmYI9NlwBEXPpS6V4sTQeiDAfBgNVHSMEGDAWgBTJRGeByOCGe/fEv4kw
DUWd2Ske3zBDBgNVHREEPDA6ggEqgglsb2NhbGhvc3SCEmt1YmVybmV0ZXMuZGVm
YXVsdIcECiAAAYcECvAQAocECvAQA4cEfwAAATANBgkqhkiG9w0BAQsFAAOCAQEA
RN0sJw4k+jYTXT71tvlvXbGDlTKoH6qA1QebGT7o+l3JYft9d2TSqf5m1CcrUB+6
yISQoHjfjGe42pMp0/ukWEnW6RDstX+CVX2WMD820d0qtddd05ChNvH1cFYeLqNw
3MgUNunQsUk0X3a3IrH2QssMb/zrGLC0hN6M39uKqMD4bGadwa/T+ywALLyYaM0f
FyQFUVBBvewBgdBJPsMR1o1lsgJ2BMxpoaSZgH5MgjEUXwkmwt4mjqt3M5pYabV6
Z8394+syWBQKz9npH5m0e7qedEdmEVYB5n9Inu6hJs5KfmvVastsxw/jSp5qT7rQ
5Q4sx+MjU5Pd3agI3ArxHQ==
-----END CERTIFICATE-----
' > kubernetes.pem
echo '-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAvaRD2IDnz3mabCcvgR2zeUzxsIAB0y5a/YCnpq0YB+nWHfan
ySLhJiXG5P+AUedsLGbJN722pHuyD10ObFej4qZhPziq2YX/+rfM0rlxXoO8w8eg
gZo+zD2qrdO6VSGO2LGJeu2r76xUKCb3jBwwS18k0OPRQ5Q/xNJA5X2QEOKUaSYH
eICHDqmlTL+TTQPAc0Rd+JMxmtB4oHe43Nqzlgo5m3nhXVo9PyiHdqSCH/OHdVWi
u7+qnZDOy8amw7EbYnwZX198Zzr7nLlYKZNuCewh4IJ+21e5frYoyw9nI1uPOJf+
BBX2pTfU8bZaRjkpNj3a54onhQGeRLb/UnCVBQIDAQABAoIBAGOWj8pyZ0mdImsJ
aPj1D/rzXTjDADJWdZIKrf/phmUhdz/k99e4aWQPEpPPWSOp1DS9BY4wImneS3Ol
+p0KqRWtKgR5Tb9Nj0+qlfVTTSXFKKvneXKV/cRj3e3K8l8icFF7aicUCOakKM2t
KPJ7GyF5pWvNN2e1wocposrhVXaHnhCMDS8uRPZr3MDYobg3mrL2nBlqdoog8QXZ
iS2I5PUPs0xH6fzY2Bg8BHJpEXppFj0LYj8gJiITW2Jb51BUPb+/pq1k36XsH/u4
Dzy1DNMgJ+YbV1a/OVS5KRlAZdNEK/1Gb/yQdqAxCxaxO86AqILwxbks7jGDXQnv
4bqN8UECgYEA728NapPwom60wRn0x4EZ5f41Ip2oTRBtv26STx11+0FB84xnyjMv
6K+CrqKCKRQ5uUJzU6bzCz+SVjKWL8QUL/gZNiP2H+b4JDAiv0e9pPY/kmLHk2lA
bXbGEtnta59+PZK3FPrXG1fgnVu3FKlNmC9Ve1q0qdfoT7Z8Ir230AsCgYEAysNG
NlZ+IQycUjE0djgHOmxcmSNodAms58xMXiaQQsKZFO+RRTAYUoekrnihbSIkFJwU
qEON3OGNqhDdFTJYnp8hBl0BuMahS4Yd1cg3EX7tssq1WFQM8TGTCFs5FAE7OhKF
SiEqAWHBDllyOKRxwzlrdnInrNFEhRWSfQ3DCS8CgYAY4Efbj91LcwcSnPjClZY0
QBITM6AdyZwtbHaFA8GTRjds72SFLIZIvZttO3Mcg35v0gibY1gTDhrNG9pgwhV6
2mL8LgZPUDbtw5aImxKIBhGayuqDVUcdWF7B7KRvLxX1nb2pz1nz/FBY6QN/gQuP
yTMvasAkeUsopQQGtAFZ+wKBgGEIcFpiq/ue8FQ5LfUBPRxNbUbv9fXKB4/qagWI
iPMZ825cc3Xb3Vfph/riycXTV9bxFsWrhoFVA5mGdnbFYDmQx5om+kL184yUA0Ui
io/54UD11zENECCA6+9M0JTtPe29nUHrexGsOVpnnczTjYmyueW2HZyLjTHvL+pe
op6LAoGBAO2diJvcQcMhfSuccEhMoBJhv2p5iCrwmxD9RdfcsX0VtDl3Eg+fAAbo
RqEBpC00dZH0H0Qv/l6wW7E69KJJ2hyADQJO/5CqvVUPDWG7BpGWDSxJto3IUvPq
ebW2WDFHsc26jXRat+tNTkLagTnnYOukTDcSaM66nDoMWoxtIk2R
-----END RSA PRIVATE KEY-----
' > kubernetes-key.pem

mkdir /var/lib/kubernetes
mv ca.pem /var/lib/kubernetes/ca.pem
mv kubernetes.pem /var/lib/kubernetes/kubernetes.pem
mv kubernetes-key.pem /var/lib/kubernetes/kubernetes-key.pem

#Install Flanneld
wget https://github.com/coreos/flannel/releases/download/v${flannel_version}/flannel-v${flannel_version}-linux-amd64.tar.gz
tar -xf flannel-v${flannel_version}-linux-amd64.tar.gz
chmod +x flanneld
sudo mv flanneld /usr/bin/flanneld

#Install Docker
wget https://get.docker.com/builds/Linux/x86_64/docker-${docker_version}.tgz
tar -xf docker-${docker_version}.tgz
sudo cp docker/docker* /usr/bin/


#Install Kubelet
wget https://storage.googleapis.com/kubernetes-release/release/v${kubernetes_version}/bin/linux/amd64/kubelet
chmod +x kubelet
sudo mv kubelet /usr/bin/kubelet


#Install Kube-proxy
wget https://storage.googleapis.com/kubernetes-release/release/v${kubernetes_version}/bin/linux/amd64/kube-proxy
chmod +x kube-proxy
sudo mv kube-proxy /usr/bin/kube-proxy

#Create gce.conf
cat > gce.conf <<EOF
[Global]
project-id=${project_id}
network-name=${network_name}
node-tags=${tags}
node-instance-prefix=${base_instance_name}
EOF

sudo mv gce.conf /var/lib/kubernetes/gce.conf

#Create kubeconfig
cat > kubeconfig <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /var/lib/kubernetes/ca.pem
    server: https://${master_lb_ip}:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubelet
  name: kubelet
current-context: kubelet
users:
- name: kubelet
  user:
    token: ${kubelet_token}
EOF

sudo mkdir /var/lib/kubelet
sudo mv kubeconfig /var/lib/kubelet/kubeconfig

#Create systemd files

cat > flannel.service <<EOF
[Unit]
Description=Flannel
Documentation=https://github.com/coreos/flannel

[Service]
ExecStart=/usr/bin/flanneld --etcd-endpoints=${etcd_endpoints} \\
  --etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem \\
  --etcd-certfile=/var/lib/kubernetes/kubernetes.pem \\
  --etcd-cafile=/var/lib/kubernetes/ca.pem \\
  --ip-masq=true

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io
After=flannel.service
Requires=flannel.service

[Service]
EnvironmentFile=/run/flannel/subnet.env
ExecStart=/usr/bin/docker daemon --bip=\$${FLANNEL_SUBNET} --mtu=\$${FLANNEL_MTU}  --iptables=false   --ip-masq=false   --host=unix:///var/run/docker.sock   --log-level=error   --storage-driver=overlay
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > kubelet.service <<EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/sudo /usr/bin/kubelet --allow-privileged=true  --require-kubeconfig=true --register-node=true --cloud-provider=gce --cloud-config=/var/lib/kubernetes/gce.conf --cluster-dns=${cluster_dns}   --cluster-domain=${cluster_domain}   --container-runtime=docker   --docker=unix:///var/run/docker.sock   --kubeconfig=/var/lib/kubelet/kubeconfig   --serialize-image-pulls=false   --tls-cert-file=/var/lib/kubernetes/kubernetes.pem   --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem   --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > kube-proxy.service <<EOF
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-proxy   --cluster-cidr=${cluster_cidr}   --kubeconfig=/var/lib/kubelet/kubeconfig   --proxy-mode=iptables   --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo mv flannel.service /etc/systemd/system/flannel.service
sudo mv docker.service /etc/systemd/system/docker.service
sudo mv kubelet.service /etc/systemd/system/kubelet.service
sudo mv kube-proxy.service /etc/systemd/system/kube-proxy.service

#Start services
sudo systemctl daemon-reload
sudo systemctl enable flannel
sudo systemctl enable docker
sudo systemctl enable kubelet
sudo systemctl enable kube-proxy
sudo systemctl start flannel
sudo systemctl start docker
sudo systemctl start kubelet
sudo systemctl start kube-proxy