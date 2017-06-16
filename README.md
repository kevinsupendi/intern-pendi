## GDP Kubernetes Exploration
Kubernetes Cluster creation involving Ansible, Terraform and Google Cloud Platform. Terraform is used for creating VMs in GCE, then configuration is automated by Ansible.
This project used Ubuntu 15.10. The result should be reproducible with any Linux machine supporting systemd services.


### Quickstart
Follow this instruction to create Kubernetes cluster automatically with Ansible and Terraform.
[here](Documentation/quickstart.md)


### Manual Setup (WIP)
Create Kubernetes cluster manually with this steps
[here](Documentation/manual_setup.md)


### Integrating with Jenkins (WIP)
Deploy Jenkins Pods, and configure continous deployment using Kubernetes plugin. With Kubernetes plugin, Jenkins can run slave on-demand with the help of Kubernetes cluster
[here](Documentation/jenkins_integration.md)


### Notes
Notes, hacks and limitations [Notes](Notes.md)


### Questions (WIP) 
[Questions](Questions.md)