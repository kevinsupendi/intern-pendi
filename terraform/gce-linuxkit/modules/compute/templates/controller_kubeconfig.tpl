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
    user: controller
  name: controller
current-context: controller
users:
- name: controller
  user:
    token: ${controller_token}