# Kubernetes Cluster Setup Using Terraform, Ansible, and Shell Scripts

This project sets up a Kubernetes cluster (1 master node and 2 worker nodes) on AWS using Terraform, Ansible, and Shell Scripts. Follow the steps below to complete the setup.

---

## Prerequisites

1. AWS account with necessary permissions to create EC2 instances, VPCs, and other resources.
2. Terraform and AWS CLI installed locally.
3. Access to a key pair to connect to the master node.

---

## Steps to Set Up the Kubernetes Cluster

### Step 1: Create Ubuntu EC2 Server for the Master Node

1. Create an Ubuntu EC2 instance with the following specifications:
    - Instance type: `t2.medium`
    - Security Group: Allow the following inbound ports:
           - SSH: 22
           - Kubernetes API: 6443
           - etcd server client API: 2379-2380
           - Kubelet API: 10250-10255
           - Cluster communication: 8472 (for Flannel) and 443
    - Key Pair: Ensure you have access to the private key file.

### Step 2: Clone the Repository

```bash
git clone https://github.com/Periyasamy10/kubernetes_cluster_creation.git
```

### Step 3: Install AWS CLI and Terraform

1. Change permissions for the script file:

```bash
chmod +x kubernetes_cluster_creation/k8s-cluster-setup/install_awscli_terraform.sh
```

2. Run the script to install AWS CLI and Terraform:

```bash
./kubernetes_cluster_creation/k8s-cluster-setup/install_awscli_terraform.sh
```

### Step 4: Configure AWS CLI

1. Run the following command to configure AWS CLI:

```bash
aws configure
```

2. Alternatively, create an `.aws` folder with the following files:

- `~/.aws/credentials`:

```plaintext
[default]
aws_access_key_id = <your-access-key-id>
aws_secret_access_key = <your-secret-access-key>
```

- `~/.aws/config`:

```plaintext
[default]
region = ap-south-1
```

### Step 5: Copy Key Pair to the Master Node

Transfer the `.pem` key file to the Ubuntu EC2 instance:

```bash
scp -i <local-key-file.pem> <local-key-file.pem> ubuntu@<master-node-ip>:/home/ubuntu/
```

### Step 6: Change Permissions of the Key Pair

```bash
chmod 600 /home/ubuntu/<pem-key-file>
```

### Step 7: Update Terraform Variables

Edit the `terraform.tfvars` file located in `kubernetes_cluster_creation/k8s-cluster-setup/terraform/`:

```plaintext
aws_region         = "ap-south-1"
ami                = "ami-023a307f3d27ea427"
vpc_id             = ""
subnet_id          = ""
security_group_id  = ""
key_pair_name      = ""
master_node_ip     = ""
worker_count       = 2
instance_type      = "t2.medium"
pem_key_path       = ""
```

Ensure the key pair used matches the one used to create the master node.

### Step 8: Execute Terraform Commands

Navigate to the Terraform directory and execute the following commands:

1. Initialize Terraform:

```bash
terraform init
```

2. Validate the Terraform configuration:

```bash
terraform validate
```

3. Plan the resource creation:

```bash
terraform plan
```

4. Apply the configuration to create resources:

```bash
terraform apply -auto-approve
```

### Step 9: Verify Kubernetes Cluster Setup

1. Check the nodes in the cluster:

```bash
kubectl get nodes
```

2. Check the namespaces:

```bash
kubectl get ns
```

### Step 10: Destroy Resources

To clean up the created resources, execute the following steps:

1. Run the following Terraform command to destroy the resources:

```bash
terraform destroy -auto-approve
```

2. Terminate the EC2 instance created for the master node.

---

## Notes

- Ensure the `kubeadm reset` tasks are complete when rerunning the playbook.
- Follow the Ansible playbook structure provided to customize cluster configurations.
- Review the `ansible/group_vars/all.yml` file for Kubernetes settings such as `kubernetes_version` and `pod_network_cidr`.

---

## Troubleshooting

- **Permission Denied Errors:** Ensure that the key pair file has correct permissions (`chmod 600`).
- **AWS CLI Issues:** Double-check the AWS configuration in `~/.aws` folder.
- **Terraform Errors:** Use `terraform refresh` to update the state if resources are modified manually.

---

## References

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [Ansible Documentation](https://docs.ansible.com/)

