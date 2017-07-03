## GDP Kubernetes Exploration
![gdp logo](https://gdpventure.com/sites/all/themes/gdp_desktop/images/gdp-logo.png)
![kubernetes logo](https://www.devopsnexus.com/user/pages/03.consultancy-areas/01.containerization/_technologies/kubernetes_logo.png)


Kubernetes Cluster creation involving Ansible, Terraform and Google Cloud Platform. 
Terraform is used for creating VMs in GCE, then configuration is automated by Ansible.
This project used Ubuntu 16.04 LTS. The result should be reproducible with any Linux machine supporting systemd services.


### Quickstart
Follow this instruction to create Kubernetes cluster automatically with Ansible and Terraform.
[here](Documentation/quickstart.md)


### Manual Setup (WIP)
Create Kubernetes cluster manually with this steps
[here](Documentation/manual_setup.md)


### After setting up
Assuming you have finished the setup and have a working kubernetes cluster, you can start deploying applications on them.
There is an ansible script called addons.yml. Run the script after cluster configuration is finished to deploy the addons automatically. 
Here is a few suggestions of useful addons and Kubernetes resources :
- [DNS](Documentation/addons/dns.md)
- [Kubernetes Dashboard (Optional Heapster)](Documentation/addons/dashboard.md)
- [Logging with EFK stack (ElasticSearch + Fluentd + Kibana)](Documentation/addons/logging.md)
- [Monitoring Resource (Heapster + InfluxDB + Grafana)](Documentation/addons/monitor.md)
- [Ingress resource](Documentation/addons/ingress.md)
- [Jenkins](Documentation/addons/jenkins.md)
- [StorageClass](Documentation/addons/storage.md)


### Notes
Notes, hacks and limitations [Notes](Notes.md)


### Questions
[Questions](Questions.md)


### Presentation
[Google Slides](https://docs.google.com/presentation/d/1tl7aIaKDEqyuU9VEx__fnUklybM0u7ZOq-AM2w0h4pA/edit?usp=sharing)


### Other Interns' Project (soon)
This section will be a collection of report and documentation about how I manage other interns' application inside Kubernetes.
Experience, issues and deployment files will be documented [here](Documentation/interns/README.md)