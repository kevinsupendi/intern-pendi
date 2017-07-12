#! /bin/bash

#Generate certificates

echo '-----BEGIN CERTIFICATE-----
MIIDuDCCAqCgAwIBAgIUKQoMZNGeGhzytkoK/TKLoL9CR8cwDQYJKoZIhvcNAQEL
BQAwYjELMAkGA1UEBhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8x
EzARBgNVBAoTCkt1YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJl
cm5ldGVzMB4XDTE3MDcxMjAxNTIwMFoXDTIyMDcxMTAxNTIwMFowYjELMAkGA1UE
BhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8xEzARBgNVBAoTCkt1
YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJlcm5ldGVzMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArnW3XUahnhLIVz/2K16bpBGxeqbg
hWvBMWNtJGShwyNqX9L/mgAEek54kdFNG/oERprSQkpESHBXA1f9laJjxZiOYL2x
jlnXZ+0VpOw9RKcauPt3u6MBoOWZZW0v/K0j8ZmLDIr1FgrlPKCK4r/p0J102xAU
n0bnAReUTyMaPstwFDXhe3HJWEJbvUMh4ArDx+4xlExDBZCRWeNyDIvb0Vq+zowC
fDCTipmMkyWUXS0oBOBPa3te6NeV7ryTrzrNR3R7p0rEodF0aBYHdopI8YNBy5H8
K8bIGTpQQQwwEaaE+4kok3AZDy67651yv+11NwlGij/AEIxInjPe6x+GmQIDAQAB
o2YwZDAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBAjAdBgNVHQ4E
FgQUK0ImeL6reqkSS7eQD0DEqy5ur2gwHwYDVR0jBBgwFoAUK0ImeL6reqkSS7eQ
D0DEqy5ur2gwDQYJKoZIhvcNAQELBQADggEBAIU2QbTW7Vhoter/pVKfBLKKLRZn
Uzsacp9XbjwCAKWGimmXsldpHrE1vGyO3x4MoYHZkTIWWMJBBihkAGuMRIGnZVHn
ZcWG8lhOz6LZ97ojXod2sxRKWzeKLndKULOx5e7TL8Bz4bKfRXE2utW/Fv6pc3X4
+zR5GJFr91skCh//VXEpPko3YNa0RHI2KEG3hMQs/IgFso7CPcXXST8dA9wjKsj2
Fsowx0RHgTMGBEt70P6bklkLZ0GikyHgx1thtQm2tbk088YFS1HVJiJJJwUwdte6
T7EWlHXvkSc6OvnT5VslPyKDA7S4LGzvX6/0Savv+345fzB5bOy3NDRoin8=
-----END CERTIFICATE-----
' > ca.pem
echo '-----BEGIN CERTIFICATE-----
MIIEJDCCAwygAwIBAgIULCk1gHjWP/Wuh+sBbCABcqZKCs4wDQYJKoZIhvcNAQEL
BQAwYjELMAkGA1UEBhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8x
EzARBgNVBAoTCkt1YmVybmV0ZXMxCzAJBgNVBAsTAkNBMRMwEQYDVQQDEwpLdWJl
cm5ldGVzMB4XDTE3MDcxMjAxNTIwMFoXDTE4MDcxMjAxNTIwMFowajELMAkGA1UE
BhMCTk8xDTALBgNVBAgTBE9zbG8xDTALBgNVBAcTBE9zbG8xEzARBgNVBAoTCkt1
YmVybmV0ZXMxEDAOBgNVBAsTB0NsdXN0ZXIxFjAUBgNVBAMTDSouZXhhbXBsZS5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDVS2QkQ/lRF+j7eANq
ROQt1Zk1md65KHLCx5oz5s2kRdFhgWK0GfDd0WDNzoWWOzxo7hUm4d7Ph4Shk4Af
RgEwlQL+QJzcog7p655rGZ7B0GJtCdAtV1K0UUcTmLfF4kHx9uVOLeOC0wiMHDPQ
s7xL+iq0YTxb1G+PpeNCZ0kVZdCrcowPFnTAoBOMFyo/Psjd8SPGC5Ek8AH3KIYK
isSH6a6yoOV3BAe09osZ4mK9X6JP2eFaJkk8s9unr/L6ksEOwnMJG+IQC2aIL4DE
tueI5+hhG2HQGWnC50RdiRzp5VPERVIXgwSEzdarm79zzp3yXcfixDvnNH3oX/+4
Q7yXAgMBAAGjgckwgcYwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUF
BwMBBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBSah2ltDOT74NRl
xeQBxpsT7taAQjAfBgNVHSMEGDAWgBQrQiZ4vqt6qRJLt5APQMSrLm6vaDBHBgNV
HREEQDA+ggEqgghtYXN0ZXItMYIJbG9jYWxob3N0ghJrdWJlcm5ldGVzLmRlZmF1
bHSHBAogAAGHBArwEAKHBH8AAAEwDQYJKoZIhvcNAQELBQADggEBABlD9egDGRVg
N6ekQmgSwppyIqBq43It+r+kVBzWjKDAuEYdn4GhtIoGLyomN/XRf+jdCHKnxT1/
LZQ1fBc3o2APIIDPPEXGRQxwfmzCA4NAEsCTGdYcLPFRLQkTnS+6sHa6NHhaZX91
vSSlHhqtCH15szoeM/FqWLHjWKMRtXz7fiDOLA4lhQ5cSayLwsD46NLK0OfLJO+U
yjHUewzC7zMscqDJssj1vvi/wJ5odAqXu67mLn8E9kzN9rJTRUbQ1QUVn5JSMWaY
J2hnpjqWqtQhY7UFa1JqB3EPupT07a+rDBAJ4zVxaiG2PKzxfx9fMcpgF5YKbn9Z
Oa49up5Jd60=
-----END CERTIFICATE-----
' > kubernetes.pem
echo '-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA1UtkJEP5URfo+3gDakTkLdWZNZneuShywseaM+bNpEXRYYFi
tBnw3dFgzc6Fljs8aO4VJuHez4eEoZOAH0YBMJUC/kCc3KIO6eueaxmewdBibQnQ
LVdStFFHE5i3xeJB8fblTi3jgtMIjBwz0LO8S/oqtGE8W9Rvj6XjQmdJFWXQq3KM
DxZ0wKATjBcqPz7I3fEjxguRJPAB9yiGCorEh+musqDldwQHtPaLGeJivV+iT9nh
WiZJPLPbp6/y+pLBDsJzCRviEAtmiC+AxLbniOfoYRth0BlpwudEXYkc6eVTxEVS
F4MEhM3Wq5u/c86d8l3H4sQ75zR96F//uEO8lwIDAQABAoIBAQCKiYBOydO650PN
acMWGA748j6kAQAX1XzMpKa0xVmWND7uDQLWJe87tA4jPtunm2v+X31flt+IfeYY
qFxUc7y8GF0sVT1NVPlI2GA6AhcKndYAKpqLiKdQNWZsBQqAPhhFF+8SW13lkDqB
/qNtEADifGeWZ32zy4R2kfHNJJbkjOBvS936YUkW+ZXdsvN3SZoH9qDt0i/aZWo9
xJXlwmn+4wTyvhlRjPAk4lGJQXem4fS6/lEQwzYg1eZlVsEMhYflQmmPXjD/IvGS
XHnlS9sI3ts2Gh3E+BChPR8VeLHJ+15aHVrsCor7Fdi3aD0bQDJTjogQp5Cv2fLE
JNIu/z8JAoGBAOuXOOFGUUM89zFMlM4BCyWN1zvgvrq1u8j9kUVFOi5q0X7hv2ak
wixo15Aed/fy08/V2WYtcOBXJu6DCDVuVkW/UkgBS01j5AGQBA58WDbGJxxhi6bH
JMOpqbY6BLcisq+sw5+40hEfTtD7qNS1jgJxNjHtDiKwClC09mT0LxSDAoGBAOfF
srEzI6ESxZ6vPs2z3DKhWmCI6WEXPaw9Nr3XxSDKL0mo5KV5yHV5fPvEN/71CzbN
oH8gGf1GZosVKwx/oiJ3Ta25H1g0i/4/ZNAY4muSHj+pJMP4qiMd5yAaJgwwVBVF
94egK1xOycWi20jgzR9JK7OgQQC/cf4cOxiQGUNdAoGBANuYDjW1FIPm7MZwCnfm
cxxjFM9EUqO4R7w11lXKDEw91t48z+p+AlvgsaUtMUfVeOdN/qEGFCOYOLqzOlCL
czD5/1kMk8MkK9/k/FMARj1v//6tUb13/GXA3Gb1t3V4izPChml3nZ7GHvIe0STL
wf22xvxMaROeIU9PDifVj5i/AoGBAOB2WL7AVisysO0jr2EsZX8rQQnozozXI0Vh
61gkVaeR6AYgaX/Q19Ddnat+tvRWgUvMDTnQ7xqZSco87/okyfMzM6mhdbfI/CN5
ZbsbvnyLgHwK5a5dbvifhy1R5bM8QtJvdnCFMDkvnL2pIVINVNqN1KMb+pgs0MtW
r+zz8WOJAoGAf1nyp8tTATuggeHgZEfJfmtSV7ccshHHV3REHc3k7jAFDKrP5xKi
vvDzxKRbyPbRrKuVtY/DMepouSo9L/VsFsZhW39Sr/lbmW4IqXp2/lAtf2PPaxMQ
yxZKP9sgK5VsexgSlWOOdEG4C9o03bGPQgs3D89H55IFrhzg+uly9RA=
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