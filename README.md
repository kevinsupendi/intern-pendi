## GDP Kubernetes Exploration
![gdp logo](https://gdpventure.com/sites/all/themes/gdp_desktop/images/gdp-logo.png)
![kubernetes logo](https://www.devopsnexus.com/user/pages/03.consultancy-areas/01.containerization/_technologies/kubernetes_logo.png)


Kubernetes Cluster creation involving  Terraform and Google Cloud Platform. 
Terraform is used for creating VMs in GCE and configure startup script.
This project used Ubuntu 16.04 LTS. The result should be reproducible with any Linux machine supporting systemd services.
There is also Docker LinuxKit exploration, though it still has limitations because GCE startup script is not supported yet.


### Quickstart
Follow this instruction to create Kubernetes cluster automatically with Terraform.
[here](Documentation/quickstart.md)


### Manual Setup
Create Kubernetes cluster manually with this steps
[here](Documentation/manual_setup.md)


### After setting up
By default only DNS, Dashboard, Cluster Autoscaler, Heapster and Storageclass addons are deployed.
You can try deploying other application or change deployed addons configuration.

Here is a few suggestions of useful addons and Kubernetes resources :
- [DNS](Documentation/addons/dns.md)
- [Kubernetes Dashboard (Optional Heapster)](Documentation/addons/dashboard.md)
- [Logging with EFK stack (ElasticSearch + Fluentd + Kibana)](Documentation/addons/logging.md)
- [Monitoring Resource (Heapster + InfluxDB + Grafana)](Documentation/addons/monitor.md)
- [Ingress resource](Documentation/addons/ingress.md)
- [Jenkins](Documentation/addons/jenkins.md)
- [StorageClass](Documentation/addons/storage.md)


### Docker LinuxKit
Run Kubernetes cluster in Docker LinuxKit.
[here](Documentation/linuxkit.md)

### Notes
Notes, hacks and limitations [Notes](Notes.md)


### Questions
[Questions](Questions.md)


### Presentation
[Google Slides](https://docs.google.com/presentation/d/1tl7aIaKDEqyuU9VEx__fnUklybM0u7ZOq-AM2w0h4pA/edit?usp=sharing)