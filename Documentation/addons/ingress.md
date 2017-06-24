### Ingress resource
Ingress is useful way to expose Kubernetes Services to External. It has several features :
- Name based virtual hosting
- URL mapping

Before deploying Ingress rule, first you must deploy Ingress controller to watch the rule in a node.

Deploy with Ansible script addons.yml or use this command in root project directory

```
kubectl apply -f deployment-example/ingress/*
```

More information about Ingress can be found in Kubernetes [docs](https://kubernetes.io/docs/concepts/services-networking/ingress/)