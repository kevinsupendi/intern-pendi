### Ingress resource
Ingress is useful way to expose Kubernetes Services to External. It has several features :
- Name based virtual hosting
- URL mapping

Before deploying Ingress rule, first you must deploy Ingress controller to watch the rule in a node.

Copy folder terraform/gce/modules/compute/files/addons/ingress/ to master VM
Deploy addons with this command in master VM

```
kubectl apply -f copied_folder/*
```

More information about Ingress can be found in Kubernetes [docs](https://kubernetes.io/docs/concepts/services-networking/ingress/)