### DNS Addons
DNS add-on is required for every Kubernetes cluster because of its useful features. Without the DNS add-on the following things will not work:

- DNS based service discovery
- DNS lookups from containers running in pods

Copy file in terraform/gce/modules/compute/files/addons/kubedns/kubedns.yaml to master VM
Deploy addons with this command in master VM

```
kubectl apply -f copied_files.yaml
```

More information about kubedns can be found in Kubernetes [docs](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)