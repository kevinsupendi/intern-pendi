## Questions

### How does API server authenticate client's request ?
There are many authentication methods, but this project use certs and token method.
Each request to the API server has to bring the correct CA file and token with the correct value.
Usually they are configured in kubeconfig files used by kubelet


### How exactly Kubernetes IP per Pod works ? Because by default Docker has an IP for each container, how Kubernetes achieve this model ?
Everytime you deploy a pod, Kubernetes automatically create one more container inside the pod, it's called pause container.
Docker has *mapped-container mode*, a container can be mapped to other container and share the same network layer.
So these so-called pause container holds the network information, and other containers just mapped to it.


### What is a Service ? Is it just like a process in the VM ?
Service is just like other Kubernetes resource, it is an API Object.
It doesn't live in the VM. It is an Object used by API Server to map Pods in Deployment to Service IP.
Every API Object is stored in etcd.


### How Kubernetes Load balance incoming request from Service to Pods ?
From Service to Pods, request are forwarded using iptables and probability rule. This is handled by kube-proxy.
Each Pod has the same probability to accept the request, but it doesn't mean every Pod will get same number of request (round robin), so it's random chances


### Is every Pod serves at the same time ? 
Yes, every Pod is active and ready to accept request that are forwarded to them.


### Can persistent volumes attach and detach to Pod automatically ? For example if Jenkins Pod mount a volume, when the Pod restart to another node, does it automatically mount again to another node?
Yes, mounting is handled automatically by Kubernetes, even across container and Pod failures. There is an exception for node failure though,
the persistent volume has to be unmount manually when node failure happens.
Maybe this behaviour will be fixed in later Kubernetes release


### How secure is Kubernetes Secrets ? Both communication and data at rest
Every Kubernetes communication is using TLS, and each request to API server must be authenticated using token (or other methods).
Kubernetes Secrets can be transferred safely to nodes and API server.
When Secrets reach the node, it is saved in tmpfs, so it never hit node disks.

However, because Secrets is Kubernetes object, it is also saved in etcd.
Etcd communication can be configured to use TLS, but Kubernetes API Object is saved in plaintext, including secrets.
It is also saved in disk, so admin should consider delete disk after use or encrypt it. 