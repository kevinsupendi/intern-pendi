### Kubernetes Dashboard

Dashboard is a handy tool to manage Kubernetes Cluster from Web GUI. It has similar function with kubectl. You can view logs, see pods, nodes, and deploy application.
If you configure Heapster, Dashboard can also show graph resources too.

Deploy addons with Ansible script addons.yml or use this command in root project directory

```
kubectl apply -f deployment-example/addons/kube-dashboard.yaml
```

More information about kube-dashboard can be found in Kubernetes [docs](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

![dashboard ui](https://kubernetes.io/images/docs/ui-dashboard-node.png)

![dashboard ui](https://kubernetes.io/images/docs/ui-dashboard-workloadview.png)

![dashboard ui](https://kubernetes.io/images/docs/ui-dashboard-logs-view.png)