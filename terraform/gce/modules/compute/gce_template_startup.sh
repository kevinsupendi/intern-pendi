#! /bin/bash

#Generate certificates

echo '-----BEGIN CERTIFICATE-----
MIIDuDCCAqCgAwIBAgIUJvssVmaKKCR6XOuL0pcn87mVkpQwDQYJKoZIhvcNAQEL
BQAwYjELMAkGA1UEBhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8x
EzARBgNVBAoTCkt1YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJl
cm5ldGVzMB4XDTE3MDcxNDA2MjcwMFoXDTIyMDcxMzA2MjcwMFowYjELMAkGA1UE
BhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8xEzARBgNVBAoTCkt1
YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJlcm5ldGVzMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApPfkiTGagIzfQT5FoLkJWOqlMn3h
r22Bbm2yccjhUGvzSeyzthNzBTUjty0EAnQD5dFfPIZ3a/IoDD6V/q6ese7jhI+m
1K5UsU2AKj2dfFXYOo5wf4JjhSR2fpSjOBYtDR2f/htmSYBiYb1RI/wqbu2J/Nla
YDzKIa9Djzs8a+xz4tPCxJKK5VkbqJsWCWh8ba8bGMZJgtyAcw/zahPIRFKWFh8w
aQfHPRoKG05nFkZwBEPOW4UIF0I7+hrbCumGCC/DPA0MdBcVt2OrPggOwO4gPD8P
kfacNvttO+h2n9JSRj0wzXY+8tKdLTC5Qmh6xKrAJvMmG+U/aPdstVxBhwIDAQAB
o2YwZDAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBAjAdBgNVHQ4E
FgQUUbDjUpBON9iX6tLo9cAC3hFnRPgwHwYDVR0jBBgwFoAUUbDjUpBON9iX6tLo
9cAC3hFnRPgwDQYJKoZIhvcNAQELBQADggEBAEpGB6ScqqDjbXR3hiH5yevd0J1T
/4KdRnc6rsfLtlRLEjEovyBPr4D+2tcUdLHO2nrfeAq3BuVYp9kWyCWIIciqBg+x
j+d9fBV+ohBm/cj+reVLERjQltATWg65SGGmc1CyC9fAKHgY1k1mzx3wmKuMe/3/
8yGa/opFbB5srwohJU0wk8xQm2R9QCkYx1oul+5nL+Jqcza5DLZ0HsBLKgHDJq3Z
/jR5ZacZpFDYPBDzptLXckbRwFrMmx/xpMU5dpuCFO3Qw8jE8ByXPBYuPmCjMWk/
uLxP84ifVamJYyuLDmrTfSdN5ufhOFeQh6gvfohZYs7/hFZBeqCcU1+x7dc=
-----END CERTIFICATE-----
' > ca.pem
echo '-----BEGIN CERTIFICATE-----
MIIEXTCCA0WgAwIBAgIUETR2GF5jUIwy2gq3ScqzzHZmnqowDQYJKoZIhvcNAQEL
BQAwYjELMAkGA1UEBhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8x
EzARBgNVBAoTCkt1YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJl
cm5ldGVzMB4XDTE3MDcxNDA2MjcwMFoXDTE4MDcxNDA2MjcwMFowdjELMAkGA1UE
BhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8xEzARBgNVBAoTCkt1
YmVybmV0ZXMxEDAOBgNVBAsTB0NsdXN0ZXIxIjAgBgNVBAMTGSouYy5pbnRlcm4t
a2V2aW4uaW50ZXJuYWwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDG
gDTqtP/IDK6s3NJPuFCKuiuksLk6cykTtzJoRDpgUpOc2Of8Wol8Rel4wl/kRaW7
QmyvnQIdPVLOTPfaYMjudMyDxV22PT6JfYNSl7BDNm9yE6FQAm5a+2dS1E+D6Fgu
U3uAiJuTQxd84vfbYsmJ9X8+Q7oYE1DN30LW4bIQZP42uhSztGo+KmcqUtCL0jnz
TvDr/XB+1nokR/MOx+DRLDJMCXbf5khy5/X4GqoB7sg7YlIIxJftFTPlZU25Un8v
e1uE8Xqy3YlnLccrGmV2R6xnbygne/mCyBv18MtvSvoo6nHJ4VKTOVrzaXcWdTG9
a2sQhunAJdH7/2lMIQLxAgMBAAGjgfYwgfMwDgYDVR0PAQH/BAQDAgWgMB0GA1Ud
JQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB0GA1UdDgQW
BBSc3xyMtCKxmJqjrBSiMmNmcSa9HDAfBgNVHSMEGDAWgBRRsONSkE432Jfq0uj1
wALeEWdE+DB0BgNVHREEbTBrgghtYXN0ZXItMYIJbG9jYWxob3N0ghJrdWJlcm5l
dGVzLmRlZmF1bHSHBAogAAGHBArwEAKHBArwEAOHBArwEASHBArwEAWHBArwEAaH
BArwEAeHBArwEAiHBArwEAmHBArwEAqHBH8AAAEwDQYJKoZIhvcNAQELBQADggEB
AJWmvXRlYUC9pIklPAGr9kqr+tq6eeox9Dr2XQdYBeiyu0RIFH+j4fyUbAOAfzAI
DRP7avC8fRHlz0Wmmu6WFrasaI+ujri6ksDOnyCAXdCZnBP/9hYasCQCxpc3plR5
WXKvtiM8ipWinYxt+2gcKF6gE/vJi87jTbzjWORqIU0/H01ZFd0sMKj5vr5ZnyjH
Rzs+IrAQHgWo0li57Ky9eHWHs4EKOHr3/WNCo3iMkgojCsZI9HGX3HLlcENmouMl
W/E4DYY+CM0CicqoUikjvBdio7YlErErwJz7EAXvyxYn/VExLVIjcmM83IeEvd0+
yNNvCOettgY2j1kn5lqvXAU=
-----END CERTIFICATE-----
' > kubernetes.pem
echo '-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxoA06rT/yAyurNzST7hQirorpLC5OnMpE7cyaEQ6YFKTnNjn
/FqJfEXpeMJf5EWlu0Jsr50CHT1Szkz32mDI7nTMg8Vdtj0+iX2DUpewQzZvchOh
UAJuWvtnUtRPg+hYLlN7gIibk0MXfOL322LJifV/PkO6GBNQzd9C1uGyEGT+NroU
s7RqPipnKlLQi9I5807w6/1wftZ6JEfzDsfg0SwyTAl23+ZIcuf1+BqqAe7IO2JS
CMSX7RUz5WVNuVJ/L3tbhPF6st2JZy3HKxpldkesZ28oJ3v5gsgb9fDLb0r6KOpx
yeFSkzla82l3FnUxvWtrEIbpwCXR+/9pTCEC8QIDAQABAoIBAAuNTocSPYiA5HF+
8GZfTaClMQEGn+D87rkNAkv7HIKai6inHukaw8GNuAalGTuJqhl5xiV6N7NH7FfB
NvNoiokGFxjcFZYTfl42Bbx6w3FF67px1gN4AMAevWaeoHoGvYsEpL1YNeWeE/Ha
q54C48O5m8wd2OipxxwUECm9PMWjYLkSrXAunJRtDw+URRxZUs70iVIbr7w1LPVZ
Vr7RaQf4b1xrm63gK2KlqzVaWkyiaKLm/8IdB6o1rLpBko/E6k385etYEiA9rnYr
W90XikB6bng3cZOYVcdguHNJxZdUNTcRcvnCkrgkE6Tbbqe8PkpJEq4gamX2WMcg
YdrGDAECgYEA1XWyLAfEczR1IpyDz2G6erJ5viN3IhD6YB4vR69WW6VlqZdZTENR
xWtp42HfrlVlDAkyLIbQQPBtNY98VrEikr5sAMPLbAPUXex3DZm+XNNAqtx6QrRW
lZ2up5AFhKA5slA6tl+h4wszLsKl6Gg0tAlTMbjKto+571PC5IDJoaECgYEA7g9V
mdBQTL/DzOa4zuqRKJ1epNiQ7Aliqxq/7c/tkfcwOkA8LKjwyS7jkcepOCampWvN
byHIudcc2wjVtqPPIUXA1Do8YIzzgnp1FARPl99BmzTpxJ/9KNj77tOUf0A/Sgr7
k3bDOrnop1y5HoKQGFCp8j9/fLqBt5nLa79mf1ECgYEAzbK3WXq6spHQduQAmO2C
OA6ZBsNCYE+gFtO/mAK841/FUeIJKVaODAJwba+5T1P3JdwOv53CPXHyq3Rzy06z
FFnv1eTXuGUQVtox96c6LFVescf5ASKrdU4YKly9FIsaTlzF10zcwd/fGKZ2Hjmc
4AlEZFvA7KAf+yLqYixBIUECgYEAzkw5mR6dx7TS4Aj9FErP2kttzhrik7maaL64
nkR3EuwMPh6WRvlsGFvq19UXftJ3zZh7IZg8U1fn6KRiV3DjOWkyLnf9BIqBJ4wp
U1xdATZ2qyKShlNC1pga0p9F63RopCiaVPMxQf4DcK14usjYSEn2zDhcqWESsmGz
l774+tECgYBiPo4Pcqjhyrp7/N1ZjDFPZ3QKEx28wWlJcjokNFJZyEKQBCmzvXzn
MXG0DL79Ge+52dXiE99Lk5gvKI4WFKFIhUzzYSjWoyfkpGpSTvGbrjreyBFXHl6l
9TRE+s61nPvk4AAl/bkqh9AFsTaycy/d5RlGrV9xRCDd/wt6F4c0vg==
-----END RSA PRIVATE KEY-----
' > kubernetes-key.pem

mkdir /var/lib/kubernetes
mv ca.pem /var/lib/kubernetes/ca.pem
mv kubernetes.pem /var/lib/kubernetes/kubernetes.pem
mv kubernetes-key.pem /var/lib/kubernetes/kubernetes-key.pem

#Install Flanneld
wget https://github.com/coreos/flannel/releases/download/v0.7.0/flannel-v0.7.0-linux-amd64.tar.gz
tar -xf flannel-v0.7.0-linux-amd64.tar.gz
chmod +x flanneld
sudo mv flanneld /usr/bin/flanneld

#Install Docker
wget https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz
tar -xf docker-1.11.2.tgz
sudo cp docker/docker* /usr/bin/


#Install Kubelet
wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubelet
chmod +x kubelet
sudo mv kubelet /usr/bin/kubelet


#Install Kube-proxy
wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kube-proxy
chmod +x kube-proxy
sudo mv kube-proxy /usr/bin/kube-proxy

#Create gce.conf
cat > gce.conf <<EOF
[Global]
project-id=intern-kevin
network-name=kubenet
node-tags=node
node-instance-prefix=node
EOF

sudo mv gce.conf /var/lib/kubernetes/gce.conf

#Create kubeconfig
cat > kubeconfig <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /var/lib/kubernetes/ca.pem
    server: https://10.240.16.2:6443
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
    token: changeme
EOF

sudo mkdir /var/lib/kubelet
sudo mv kubeconfig /var/lib/kubelet/kubeconfig

#Create systemd files

cat > flannel.service <<EOF
[Unit]
Description=Flannel
Documentation=https://github.com/coreos/flannel

[Service]
ExecStart=/usr/bin/flanneld --etcd-endpoints=https://10.240.16.2:2379 \\
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
ExecStart=/usr/bin/docker daemon --bip=\${FLANNEL_SUBNET} --mtu=\${FLANNEL_MTU}  --iptables=false   --ip-masq=false   --host=unix:///var/run/docker.sock   --log-level=error   --storage-driver=overlay
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
ExecStart=/usr/bin/sudo /usr/bin/kubelet --allow-privileged=true   --api-servers=https://10.240.16.2:6443  --cloud-provider=gce --cloud-config=/var/lib/kubernetes/gce.conf --cluster-dns=10.32.0.10   --cluster-domain=cluster.local   --container-runtime=docker   --docker=unix:///var/run/docker.sock   --kubeconfig=/var/lib/kubelet/kubeconfig   --serialize-image-pulls=false   --tls-cert-file=/var/lib/kubernetes/kubernetes.pem   --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem   --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > kube-proxy.service <<EOF
[Unit]
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-proxy   --cluster-cidr=10.200.0.0/16   --kubeconfig=/var/lib/kubelet/kubeconfig   --proxy-mode=iptables   --v=2
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