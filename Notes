Notes on this Project :
- Kubernetes cluster created using Kubernetes binary v1.6.4, using systemd, installed in Ubuntu 16.04 image from GCE
- Jenkins mounted on host machine (/home/kevinsupendi96/jenkins in this case), not on persistent disk. If the pod is deleted, all jenkins configuration will be deleted as well
- I use kubenet network plugin (default), that creates new cbr0 bridge when deploying pods. Make sure docker in each node connect to cbr0 bridge
- When configuring Jenkins build executor, use 'jnlp' for container name and pod name
- I use sudo chmod 777 /var/run/docker.sock to hack with docker inside docker for jenkins easy configuration :p

Notes on Ansible :
- Routing not yet automated
- Must run init.yml once before running other files