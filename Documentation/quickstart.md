1. Create GCE instances using terraform
   - cd to terraform directory
   - configure service account and provider in gce.tf
   - run terraform apply

2. Copy terraform output to ansible/inventories/inv.ini
3. Disable ansible host checking verification
    export ANSIBLE_HOST_KEY_CHECKING=False

4. Run command from ansible/
    ansible-playbook  -i inventories/inv.ini --private-key=~/.ssh/google_compute_engine kubernetes.yml