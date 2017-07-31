#!/bin/bash

#Check cfssl binary
if ! type "cfssl" > /dev/null; then
  wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 >/dev/null 2>&1 && chmod +x cfssl_linux-amd64 && sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
fi

#Check cfssljson binary
if ! type "cfssljson" > /dev/null; then
  wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 >/dev/null 2>&1 && chmod +x cfssljson_linux-amd64 && sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
fi

#Generate CA

echo '{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}' > ca-config.json

echo '{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NO",
      "L": "Oslo",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oslo"
    }
  ]
}' > ca-csr.json

cfssl gencert -initca ca-csr.json  2>/dev/null | cfssljson -bare ca


#Generate server certificate
echo '{
  "CN": "*.c.intern-kevin.internal",
  "hosts": [
    ' "\"${kube_svc}\"" ',' "\"${masters_ip}\"" ',' "\"${masters_name}\"" ',' "\"${lb_ip}\"" ',"localhost","127.0.0.1","kubernetes.default","kubernetes","kubernetes.default.svc","kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NO",
      "L": "Oslo",
      "O": "Kubernetes",
      "OU": "Cluster",
      "ST": "Oslo"
    }
  ]
}
' > kubernetes-csr.json

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json  2>/dev/null  | cfssljson -bare kubernetes

#Cleaning up

rm ca.csr
rm ca-config.json
rm ca-csr.json
rm ca-key.pem
rm kubernetes.csr
#rm kubernetes-csr.json

mv ca.pem modules/compute/temp/ca.pem
mv kubernetes.pem modules/compute/temp/kubernetes.pem
mv kubernetes-key.pem modules/compute/temp/kubernetes-key.pem
mv kubernetes-csr.json modules/compute/temp/kubernetes-csr.json