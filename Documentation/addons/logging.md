### EFK Stack
Deploy EFK Stack to collect logs from each nodes. Fluentd is deployed as DaemonSet.
DaemonSet ensure each node will get one pod, so every node will run Fluentd.

Deploy addons with Ansible script addons.yml or use this command in root project directory

```
kubectl apply -f deployment-example/fluentd/*
```

More information about EFK can be found in Kubernetes [docs](https://kubernetes.io/docs/tasks/debug-application-cluster/logging-elasticsearch-kibana/)