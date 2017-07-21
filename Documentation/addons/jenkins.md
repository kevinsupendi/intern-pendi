### Jenkins
Deploy Jenkins pod to Kubernetes with Persistent Volumes.
With Kubernetes Plugin, Jenkins can tell Kubernetes to deploy on-demand slave to finish builds

Copy folder terraform/gce/modules/compute/files/addons/jenkins/ to master VM
Deploy addons with this command in master VM


### Create PersistentVolumeClaims
Edit jenkins_pvc.yaml file then deploy it to kubernetes
Edit jenkins.yaml and change volume claim name to your PVC name.


### Deploy Jenkins

```
kubectl create namespace jenkins
kubectl create secret generic jenkins --from-file=deployment-example/jenkins/options --namespace=jenkins
kubectl apply -f copied_folder/*
```

