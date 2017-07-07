## Notes

### Notes on this Project :
- Kubernetes cluster created using Kubernetes binary v1.6.4, using systemd, installed in Ubuntu 16.04 LTS image, tested on GCE
- When configuring Jenkins build executor, use 'jnlp' for container name and pod name
- I use sudo chmod 777 /var/run/docker.sock to hack with docker permission, because jenkins slave cannot use the socket as jenkins user :p
- Communication is authenticated using client CA and token. Any user calling API server must provide the credentials. Kubernetes component like kubelet, kube-proxy use kubeconfig to provide those credentials
- To access cloud provider features like gce or aws dynamic storage provisioning, one must set the argument --cloud-provider and --cloud-config to kubelet, kube-apiserver, and kube-controller-manager systemd files. Make sure each instance have access to service account, it should already be automated in terraform though 

### Notes on Ansible :
- Must run init.yml once before running other files

### Cloud Provider config :
- kube-controller-manager argument allocate-node-cidrs must be true to configure cloud routing

### Persistent Volumes :
- Still bugged when node dies, volume cannot be automatically detached from pod, must restart node or delete node or detach volume manually in GCP console