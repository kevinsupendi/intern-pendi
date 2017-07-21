### Kubernetes Dashboard

Dashboard is a handy tool to manage Kubernetes Cluster from Web GUI. It has similar function with kubectl. You can view logs, see pods, nodes, and deploy application.
If you configure Heapster, Dashboard can also show graph resources too.

Copy file in terraform/gce/modules/compute/files/addons/kubedashboard/kube-dashboard.yaml to master VM
Deploy addons with this command in master VM

```
kubectl apply -f copied_files.yaml
```

More information about kube-dashboard can be found in Kubernetes [docs](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

![dashboard ui](https://kubernetes.io/images/docs/ui-dashboard-node.png)

![dashboard ui](https://kubernetes.io/images/docs/ui-dashboard-workloadview.png)

![dashboard ui](https://kubernetes.io/images/docs/ui-dashboard-logs-view.png)