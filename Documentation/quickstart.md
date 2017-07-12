## Quickstart
This instructions will install Kubernetes cluster on GCP with default configuration 1 master and 1 node instance.
In the end of the quickstart, you will have a working Kubernetes cluster with addons for logging, monitoring and dashboard.
See below for list of addons.

### Prerequisites
- Install Terraform (Recommended version : >0.9.8) [link](https://www.terraform.io/intro/getting-started/install.html)
- Install Ansible (Recommended version : >2.3.0.0) [link](http://docs.ansible.com/ansible/intro_installation.html)


### Setting SSH keys
Create SSH keys to connect to VM instances.
If you have existing key pairs (~/.ssh/id_rsa for example) then you can skip this step and use that key.
If you want to generate new public private key pair, run this command :

```
ssh-keygen -t rsa -C "changethiscomment"
```

Press enter for default filepath in ~/.ssh/id_rsa

Use this key as a `--private-key` parameter when running Ansible script



### Create credentials

1. In the terminal, go to git root project
2. Run ./certs.sh, this script will generate certs and automatically put it in Terraform and Ansible configuration

    ```
    ./certs.sh
    ```


### Create the machines with Terraform
Create VMs (I used GCE in this project) using terraform. Terraform can create and destroy instances using the same .tf files.

1. Go to terraform directory
2. Open gce.tf
3. Configure the cloud provider resource bracket in gce.tf, change credentials, project and region. Here is how to get gce json credentials 
[here](https://www.terraform.io/docs/providers/google/index.html#authentication-json-file), change the file path to your liking
4. Configure filepath for SSH public key in each etcd, master, node component inside the metadata block. Change the following with your own username and your filepath
    ```
    metadata {
      block-project-ssh-keys="true"
      ssh-keys = "pendi:${file("~/.ssh/id_rsa.pub")}"
    }
    ```
5. Edit variables.tf to change the number of master instances (default 1)
6. Now open terminal in the same directory, run command :

    ```
    terraform apply
    ```

7. If the command ran succesfully, it should produce output similar to this. 

    ```
    ansible_inventory = [etcd]
    etcd-1  ansible_host=xx.xx.xx.xx internal_ip=xx.xx.xx.xx
    .
    .
    etcd-x  ansible_host=xx.xx.xx.xx internal_ip=xx.xx.xx.xx

    [master]
    master-1  ansible_host=xx.xx.xx.xx internal_ip=xx.xx.xx.xx
    .
    .
    master-x  ansible_host=xx.xx.xx.xx internal_ip=xx.xx.xx.xx
    ```

Copy terraform output to ansible/inventories/inv.ini excluding the 'ansible_inventory =' part.

At this point, you should have instances and network created in Google Cloud Platform, you can check in console.


### Securing Kubernetes
In this project I use token authentication for Kubelet, Scheduler, and Controller-manager. 
Change tokens value in ansible/group_vars/all.
Run this command to generate token value


```
head -c 16 /dev/urandom | od -An -t x | tr -d ' '
```

Run this script 3 times and replace token value for kubelet, scheduler and controller.

More information about kubernetes token can be found [here](https://kubernetes.io/docs/admin/kubelet-tls-bootstrapping/)


Apiserver will authenticate user written in ansible/roles/kube_apiserver/files/authorization-policy.jsonl.
Each kubernetes component will present token and user to Apiserver using kubeconfig (e.g. kubelet will use ansible/roles/kubelet/templates/kubeconfig.j2 for its authentication)


### Change GCP Project
Change project name value in ansible/group_vars/all to your project name.


### Run Ansible script
Ansible will configure the machine which is provided in inventories/inv.ini, the final result is a working kubernetes cluster.
the script kubernetes.yml is divided into 4 parts, init.yml, etcd.yml, master.yml and node.yml.
You can run the script individually, but each machine has to run init.yml once.

1. Disable ansible host checking verification

    ```
    export ANSIBLE_HOST_KEY_CHECKING=False
    ```

2. (Optional) If you use password protected private key, you can run this command to avoid retyping password (assuming your key is ~/.ssh/id_rsa)

    ```
    ssh-agent bash
    ssh-add ~/.ssh/id_rsa
    ```

3. Run command from ansible/ (You should provide the private key used for SSH, by default it's in ~/.ssh/ and your username that was configured in Terraform)

    ```
    ansible-playbook  -i inventories/inv.ini --private-key=~/.ssh/id_rsa kubernetes.yml -u pendi
    ```

4. After the script finished, you could check if the nodes has registered using this command in master instance 

    ```
    kubectl get nodes
    ```

You should see that the nodes are registered and in ready state.


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
- http://${NODE_EXTERNAL_IP}/kibana/
- http://${NODE_EXTERNAL_IP}/grafana/

Usually Kibana will give error because kibana pod takes time to setup for the first time.
Wait a little longer until the service is up.

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
By default all addons below will be automatically deployed in the process, except for Jenkins application.
You can try deploying several application or change deployed addons configuration.

List of addons :
- [DNS](addons/dns.md)
- [Kubernetes Dashboard (Optional Heapster)](addons/dashboard.md)
- [Logging with EFK stack (ElasticSearch + Fluentd + Kibana)](addons/logging.md)
- [Monitoring Resource (Heapster + InfluxDB + Grafana)](addons/monitor.md)
- [Ingress resource](addons/ingress.md)
- [Jenkins](addons/jenkins.md)
- [StorageClass](addons/storage.md)