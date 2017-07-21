### StorageClass
Deploy default storage class to enable dynamic provisioning in Kubernetes cluster

Copy file in terraform/gce/modules/compute/files/addons/storageclass/default.yaml to master VM
Deploy addons with this command in master VM

```
kubectl apply -f copied_file.yaml
```


More information about kubedns can be found in Kubernetes [docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)