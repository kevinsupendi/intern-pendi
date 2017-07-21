### Heapster Addons
Heapster is monitoring application that can save cluster memory, CPU and network usage, then the result can be shown in
a graph with Grafana or Kubernetes Dashboard

Copy folder in terraform/gce/modules/compute/files/addons/heapster/ to master VM
Deploy addons with this command in master VM

```
kubectl apply -f copied_folder/*
```

More information about kubedns can be found in Kubernetes [docs](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)