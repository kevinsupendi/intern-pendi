### Heapster Addons
Heapster is monitoring application that can save cluster memory, CPU and network usage, then the result can be shown in
a graph with Grafana or Kubernetes Dashboard

Deploy addons with Ansible script addons.yml or use this command in root project directory

```
kubectl apply -f deployment-example/heapster/*
```

More information about kubedns can be found in Kubernetes [docs](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)