# Master node setup (local machine assumed as master)
resource "null_resource" "master_node_setup" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update -y &&
      sudo apt-get install -y ansible python3
    EOT
  }
}

# Worker node creation
resource "aws_instance" "worker" {
  count         = var.worker_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  tags = {
    Name = "worker-node-${count.index}"
  }
}

# Wait for worker instances to be ready
resource "null_resource" "wait_for_workers" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 60
    EOT
  }

  depends_on = [aws_instance.worker]
}

# Generate inventory file dynamically
resource "local_file" "inventory" {
  content = <<EOT
[master]
${var.master_node_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/kubernetes.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[worker]
%{ for ip in aws_instance.worker.*.private_ip }
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/kubernetes.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor }
EOT

  filename = "/home/ubuntu/kubernetes_cluster_creation/k8s-cluster-setup/ansible/inventory.ini"
}

# Run Ansible playbook
resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook /home/ubuntu/kubernetes_cluster_creation/k8s-cluster-setup/ansible/setup_kubernetes.yml \
        -i /home/ubuntu/kubernetes_cluster_creation/k8s-cluster-setup/ansible/inventory.ini
    EOT
  }

  depends_on = [local_file.inventory, null_resource.wait_for_workers, null_resource.master_node_setup]
}
