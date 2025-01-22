# Master node configuration (local machine assumed as master)
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
  ami           = var.ami # Amazon Linux 2 AMI
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  tags = {
    Name = "worker-node-${count.index}"
  }
}

# Generate inventory file dynamically
resource "local_file" "inventory" {
  content = <<EOT
[master]
${var.master_node_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[worker]
%{ for ip in aws_instance.worker.*.private_ip }
${ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa
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

  depends_on = [local_file.inventory, aws_instance.worker, null_resource.master_node_setup]
}