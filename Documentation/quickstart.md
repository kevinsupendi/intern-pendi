## Quickstart

### Create the machines with Terraform
Create VMs (I used GCE in this project) using terraform. Terraform can create and destroy instances using the same .tf files.

1. Go to terraform directory
2. Open gce.tf
3. Configure the cloud provider resource bracket in gce.tf, change credentials, project and region. Here is how to get gce json credentials 
[here](https://www.terraform.io/docs/providers/google/index.html#authentication-json-file), change the file path to your liking
4. Edit variables.tf to change the number of etcd, master and node instances
5. Now open terminal in the same directory, run command :

    ```
    terraform apply
    ```

5. If the command ran succesfully, it should produce output with green colors. Copy terraform output to ansible/inventories/inv.ini

At this point, you should have instances and network created in Google Cloud Platform, you can check in console.


### Create credentials

1. In the terminal, go to ansible/roles/certs/files directory
2. This requires the `cfssl` and `cfssljson` binaries. Download them from the [cfssl repository](https://pkg.cfssl.org).

    ### OS X

    ```
    wget https://pkg.cfssl.org/R1.2/cfssl_darwin-amd64
    chmod +x cfssl_darwin-amd64
    sudo mv cfssl_darwin-amd64 /usr/local/bin/cfssl
    ```

    ```
    wget https://pkg.cfssl.org/R1.2/cfssljson_darwin-amd64
    chmod +x cfssljson_darwin-amd64
    sudo mv cfssljson_darwin-amd64 /usr/local/bin/cfssljson
    ```

    ### Linux

    ```
    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
    chmod +x cfssl_linux-amd64
    sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
    ```

    ```
    wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
    chmod +x cfssljson_linux-amd64
    sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
    ```

    ### Set up a Certificate Authority

3. Create a CA configuration file:

    ```
    echo '{
      "signing": {
        "default": {
          "expiry": "8760h"
        },
        "profiles": {
          "kubernetes": {
            "usages": ["signing", "key encipherment", "server auth", "client auth"],
            "expiry": "8760h"
          }
        }
      }
    }' > ca-config.json
    ```

4. Create a CA certificate signing request:
    ```
    echo '{
      "CN": "Kubernetes",
      "key": {
        "algo": "rsa",
        "size": 2048
      },
      "names": [
        {
          "C": "NO",
          "L": "Oslo",
          "O": "Kubernetes",
          "OU": "CA",
          "ST": "Oslo"
        }
      ]
    }' > ca-csr.json
    ```
5. Generate a CA certificate and private key:

    ```
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca
    ```

    Results:

    ```
    ca-key.pem
    ca.pem
    ```
Make sure ca.pem, kubernetes.pem and kubernetes-key.pem exist in ansible/roles/certs/files directory, as those files will
be used by Ansible to generate certificates


### Run Ansible script
Ansible will configure the machine which is provided in inventories/inv.ini, the final result is a working kubernetes cluster.
the script kubernetes.yml is divided into 4 parts, init.yml, etcd.yml, master.yml and node.yml.
You can run the script individually, but each machine has to run init.yml once.

1. Disable ansible host checking verification

    ```
    export ANSIBLE_HOST_KEY_CHECKING=False
    ```

2. Run command from ansible/ (You should provide the private key used for SSH, by default it's in ~/.ssh/)

    ```
    ansible-playbook  -i inventories/inv.ini --private-key=~/.ssh/google_compute_engine kubernetes.yml
    ```

3. After the script finished, you could check if the nodes has registered using this command in master instance 

    ```
    kubectl get nodes
    ```

You should see that the nodes are registered and in ready state.


### Testing
Eventhough your nodes are ready, you should test if your Service and Deployment can work well.

1. Run this command to deploy nginx application

    ```
    kubectl run nginx --image=nginx --port=80 --replicas=3
    ```

2. Check the pods' statuses

    ```
    kubectl get pods -o wide
    ```

    Make sure they are running

3. Expose the Service with type NodePort

    ```
    kubectl expose deployment nginx --type NodePort
    ```

4. Get the Service Port

    ```
    kubectl get svc
    ```

    You should see Port with value 80:30000ish

5. Test the nginx service using cURL or web browser:

    ```
    curl http://${NODE_PUBLIC_IP}:${NODE_PORT}
    ```


### What's next ?
Your Kubernetes should be running well and has been tested. Now the next step is deploy some addons to extend
Kubernetes functionality
- [DNS](Documentation/addons/dns.md)
- [Kubernetes Dashboard (Optional Heapster)](Documentation/addons/dashboard.md)
- [Logging with EFK stack (ElasticSearch + Fluentd + Kibana)](Documentation/addons/logging.md)
- [Monitoring Resource (Heapster + InfluxDB + Grafana)](Documentation/addons/monitor.md)
- [Ingress resource](Documentation/addons/ingress.md)
- [Jenkins](Documentation/addons/jenkins.md)
- [StorageClass](Documentation/addons/storage.md)