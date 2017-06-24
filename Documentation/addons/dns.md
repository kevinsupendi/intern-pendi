### DNS Addons
DNS add-on is required for every Kubernetes cluster because of its useful features. Without the DNS add-on the following things will not work:

- DNS based service discovery
- DNS lookups from containers running in pods

Deploy addons with Ansible script addons.yml or use this command in root project directory

```
kubectl apply -f deployment-example/addons/kubedns.yaml
```

More information about kubedns can be found in Kubernetes [docs](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)