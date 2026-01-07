#!/bin/bash
set -e

MASTER_IP="192.168.0.101"
WORKER_IPS=("192.168.0.121" "192.168.0.122")
SSH_KEY="${SSH_KEY:-~/Projects/.ssh/id_ed25519}"
SSH_USER="${SSH_USER:-ubuntu}"

echo "=== Generating Ansible Inventory ==="
cat > inventory.ini <<EOF
[k8s_masters]
cp-1 ansible_host=${MASTER_IP}

[k8s_workers]
EOF

for i in "${!WORKER_IPS[@]}"; do
    echo "worker-$((i+1)) ansible_host=${WORKER_IPS[$i]}" >> inventory.ini
done

cat >> inventory.ini <<EOF

[k8s_cluster:children]
k8s_masters
k8s_workers

[k8s_cluster:vars]
ansible_user=${SSH_USER}
ansible_ssh_private_key_file=${SSH_KEY}
ansible_python_interpreter=/usr/bin/python3
EOF

echo "=== Running Ansible Playbook ==="
ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -i inventory.ini ansible/main.yml "$@"

echo ""
echo "=== ✅ Cluster Setup Complete ==="
echo "Copy kubeconfig: scp ${SSH_USER}@${MASTER_IP}:~/.kube/config ~/.kube/config"
echo "Check nodes:     kubectl get nodes"
echo "Check pods:      kubectl get pods -A"