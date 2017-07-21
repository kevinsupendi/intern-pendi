#!/bin/bash

#Check cfssl binary
if ! type "cfssl" > /dev/null; then
  wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 >/dev/null 2>&1 && chmod +x cfssl_linux-amd64 && sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
fi

#Check cfssljson binary
if ! type "cfssljson" > /dev/null; then
  wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 >/dev/null 2>&1 && chmod +x cfssljson_linux-amd64 && sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
fi

#Check jq binary
if ! type "jq" > /dev/null; then
  wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 >/dev/null 2>&1 && chmod +x jq-linux64 && sudo mv jq-linux64 /usr/local/bin/jq
fi

eval "$(jq -r '@sh "kube_svc=\(.kube_svc) masters_ip=\(.masters_ip) masters_name=\(.masters_name) lb_ip=\(.lb_ip)"')"

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
    ' "\"$kube_svc\"" ',' "$masters_ip" ',' "$masters_name" ',' "\"$lb_ip\"" ',"localhost","127.0.0.1","kubernetes.default","kubernetes","kubernetes.default.svc","kubernetes.default.svc.cluster.local"
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

capem=$(cat ca.pem)
kubernetespem=$(cat kubernetes.pem)
kuberneteskeypem=$(cat kubernetes-key.pem)

jq -n --arg capem "$capem" --arg kubernetespem "$kubernetespem" --arg kuberneteskeypem "$kuberneteskeypem" '{"capem":$capem, "kubernetespem":$kubernetespem, "kuberneteskeypem":$kuberneteskeypem}'

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