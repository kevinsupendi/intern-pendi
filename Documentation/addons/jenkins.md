### Jenkins
Deploy Jenkins pod to Kubernetes with Persistent Volumes.
With Kubernetes Plugin, Jenkins can tell Kubernetes to deploy on-demand slave to finish builds

Deploy addons with Ansible script addons.yml or use this command in root project directory


### Create Default StorageClass
Create GCE storage class so dynamic provisioning can be used

```
kubectl apply -f deployment-example/storageclass/gce/default.yaml
```


### Create PersistentVolumeClaims
Edit deployment-example/persistentvolume/pvc.yaml file then deploy it to kubernetes

```
kubectl apply -f deployment-example/persistentvolume/pvc.yaml
```

Edit deployment-example/jenkins/jenkins.yaml and change volume claim name to your PVC name.


### Deploy Jenkins

```
kubectl create namespace jenkins
kubectl create secret generic jenkins --from-file=deployment-example/jenkins/options --namespace=jenkins
kubectl apply -f deployment-example/jenkins/*
```

