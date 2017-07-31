apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /var/lib/kubernetes/ca.pem
    server: https://${internal_ip}:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: scheduler
  name: scheduler
current-context: scheduler
users:
- name: scheduler
  user:
    token: ${scheduler_token}