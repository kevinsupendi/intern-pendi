## Quickstart
This instructions will install Kubernetes cluster on GCP with default configuration 1 master and 1 node instance.
In the end of the quickstart, you will have a working Kubernetes cluster with addons for logging, monitoring and dashboard.
See below for list of addons.

### Prerequisites
- Install Terraform (Recommended version : >0.9.8) [link](https://www.terraform.io/intro/getting-started/install.html)


### Create credentials

1. In the terminal, go to terraform/gce/
2. Run ./certs.sh, this script will generate certs and automatically put it in Terraform startup script.

    ```
    ./certs.sh
    ```

### Securing Kubernetes
In this project I use token authentication for Kubelet, Scheduler, and Controller-manager. 
Change tokens value in terraform/gce/terraform.tfvars
Run this command to generate token value


```
head -c 16 /dev/urandom | od -An -t x | tr -d ' '
```

Run this script 3 times and replace token value for kubelet, scheduler and controller.

More information about kubernetes token can be found [here](https://kubernetes.io/docs/admin/kubelet-tls-bootstrapping/)


Apiserver will authenticate user written in terraform/gce/module/compute/files/authorization-policy.jsonl.
You can edit this file to change authorization policy.
Each kubernetes component will present token and user to Apiserver using kubeconfig (e.g. kubelet will use ansible/roles/kubelet/templates/kubeconfig.j2 for its authentication).


### Change GCP Project
Change project name value in terraform/gce/terraform.tfvars


### Create the machines with Terraform
Create VMs (I used GCE in this project) using terraform. Terraform can create and destroy instances using the same .tf files.

1. Go to terraform directory
2. Configure the cloud provider in terraform/gce/terraform.tfvars. Here is how to get gce json credentials 
[here](https://www.terraform.io/docs/providers/google/index.html#authentication-json-file), change the file path to your liking
3. Configure other variables in terraform/gce/terraform.tfvars. Multi master setup is not yet supported
4. Now open terminal in the same directory, run command :

    ```
    terraform get
    terraform apply
    ```

5. If the command ran succesfully, you should have Kubernetes cluster running

You could check if the nodes has registered using this command in master instance 

```
kubectl get nodes
```

Notes : You need to wait a couple of minutes for the startup script to finish

## Testing
Notes : Whenever kubectl command is called, it should be done inside the master VM.

### Testing Service and Deployment
Even though your nodes are ready, you should test if your Service and Deployment can work well.

1. Run this command to deploy nginx application

    ```
    kubectl run nginx --image=nginx --port=80 --replicas=3
    ```

2. Check the pods' statuses

    ```
    kubectl get pods -o wide
    ```

    Make sure they are running

3. Expose the Service with type LoadBalancer

    ```
    kubectl expose deployment nginx --type LoadBalancer
    ```

4. Get the Service Port and External IP

    ```
    kubectl get svc
    ```

    Wait until the service got external IP

5. Test the nginx service using cURL or web browser :

    ```
    curl http://${SVC_EXTERNAL_IP}
    ```

6. Clean up

    ```
    kubectl delete deployment nginx
    kubectl delete svc nginx
    ```


### Testing Addons and Ingress
Ingress has URL mapping feature so deployed addons can be accessed easily from the browser.
See which node has nginx-ingress-controller pod.

```
kubectl -n kube-system get po -o wide
```

Test if addons and Ingress have worked correctly by accessing these urls (don't forget the slash at the end of the link) :

- http://${NODE_EXTERNAL_IP}/dashboard/
- http://${NODE_EXTERNAL_IP}/grafana/


### Testing Dynamic Provisioning
Storage class is deployed by default and ready to use Dynamic Provisioning feature.

1. Create file named test.yaml inside master-1 VM instance, it must specify storageClassName to use dynamic provisioning :

	```
	kind: PersistentVolumeClaim
	apiVersion: v1
	metadata:
	  name: test
	spec:
	  accessModes:
	    - ReadWriteOnce
	  resources:
	    requests:
	      storage: 10Gi
	  storageClassName: standard
	```
2. Run kubectl apply inside master-1 VM

	```
	kubectl apply -f test.yaml
	```
3. Check in Google Cloud Console if the disk has been created correctly
4. Clean up

	```
	kubectl delete pvc test
	```
5. Check in Google Cloud Console if the disk has been deleted

### Testing Cluster Autoscaler
Test cluster autoscaler addons by deploying too much pods in one node

1. Run this command to deploy nginx application

    ```
    kubectl run nginx --image=nginx --port=80 --replicas=150
    ```

2. Wait 5 minutes
3. Check in Google Cloud Console if there is a new node created
4. Clean up

    ```
    kubectl delete deployment nginx
    ```
5. Wait 10 minutes
6. Check in Google Cloud Console if the node has been deleted

### What's next ?
By default all addons below will be automatically deployed in the process, except for Jenkins and Kibana application.
You can try deploying several application or change deployed addons configuration.

List of addons :
- [DNS](addons/dns.md)
- [Kubernetes Dashboard (Optional Heapster)](addons/dashboard.md)
- [Logging with EFK stack (ElasticSearch + Fluentd + Kibana)](addons/logging.md)
- [Monitoring Resource (Heapster + InfluxDB + Grafana)](addons/monitor.md)
- [Ingress resource](addons/ingress.md)
- [Jenkins](addons/jenkins.md)
- [StorageClass](addons/storage.md)