#!/bin/bash

#Check cfssl binary
if ! type "cfssl" > /dev/null; then
  wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && chmod +x cfssl_linux-amd64 && sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
fi

#Check cfssljson binary
if ! type "cfssljson" > /dev/null; then
  wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && chmod +x cfssljson_linux-amd64 && sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
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

cfssl gencert -initca ca-csr.json | cfssljson -bare ca


#Generate server certificate
echo '{
  "CN": "*",
  "hosts": [
    "10.32.0.1","192.168.45.131","192.168.45.132","192.168.45.133","kubekube1","kubekube2","kubekube3","localhost","127.0.0.1","kubernetes.default"
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

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

perl -pe 's/capem/`cat ca.pem`/e' terraform/gce/gce_template_startup > terraform/gce/gce_template_startup.sh
perl -i -pe 's/kubernetespem/`cat kubernetes.pem`/e' terraform/gce/gce_template_startup.sh
perl -i -pe 's/kuberneteskeypem/`cat kubernetes-key.pem`/e' terraform/gce/gce_template_startup.sh


mv ca.pem ansible/roles/certs/files/ca.pem
mv kubernetes.pem ansible/roles/certs/files/kubernetes.pem
mv kubernetes-key.pem ansible/roles/certs/files/kubernetes-key.pem

#Cleaning up
rm ca.csr
rm ca-config.json
rm ca-csr.json
rm ca-key.pem
rm kubernetes.csr
rm kubernetes-csr.json
