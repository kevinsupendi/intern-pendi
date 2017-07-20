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
  "CN": "*.c.intern-kevin.internal",
  "hosts": [
    "10.32.0.1",${masters_ip},${masters_name},"${lb_ip}","*","localhost","127.0.0.1","kubernetes.default"
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

perl -pe 's/capem/`cat ca.pem`/e' modules/compute/gce_template_startup > modules/compute/gce_template_startup.sh.tpl
perl -i -pe 's/kubernetespem/`cat kubernetes.pem`/e' modules/compute/gce_template_startup.sh.tpl
perl -i -pe 's/kuberneteskeypem/`cat kubernetes-key.pem`/e' modules/compute/gce_template_startup.sh.tpl

perl -pe 's/capem/`cat ca.pem`/e' modules/compute/gce_master_startup > modules/compute/gce_master_startup.sh.tpl
perl -i -pe 's/kubernetespem/`cat kubernetes.pem`/e' modules/compute/gce_master_startup.sh.tpl
perl -i -pe 's/kuberneteskeypem/`cat kubernetes-key.pem`/e' modules/compute/gce_master_startup.sh.tpl

#Cleaning up

rm ca.csr
rm ca-config.json
rm ca-csr.json
rm ca-key.pem
rm kubernetes.csr
rm kubernetes-csr.json
rm ca.pem
rm kubernetes.pem
rm kubernetes-key.pem