### EFK Stack
Deploy EFK Stack to collect logs from each nodes. Fluentd is deployed as DaemonSet.
DaemonSet ensure each node will get one pod, so every node will run Fluentd.

Copy folder in terraform/gce/modules/compute/files/addons/fluentd to master VM
Deploy addons with this command in master VM

```
kubectl apply -f copied_folder/*
```

More information about EFK can be found in Kubernetes [docs](https://kubernetes.io/docs/tasks/debug-application-cluster/logging-elasticsearch-kibana/)