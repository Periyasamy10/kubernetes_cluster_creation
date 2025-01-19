variable "aws_region" {
  description = "AWS region for deploying resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where instances will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where instances will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for worker nodes"
  type        = string
  default     = "t2.medium"
}

variable "master_node_ip" {
  description = "Public IP of the master node"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "key_pair_name" {
  description = "AWS Key Pair name for SSH access"
  type        = string
}
