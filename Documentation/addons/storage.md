### StorageClass
Deploy default storage class to enable dynamic provisioning in Kubernetes cluster

Deploy with Ansible script addons.yml or use this command in root project directory

```
kubectl apply -f deployment-example/storageclass/gce/default.yaml
```

More information about kubedns can be found in Kubernetes [docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)