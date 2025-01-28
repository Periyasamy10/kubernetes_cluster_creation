aws_region         = "ap-south-1"
ami                = "ami-023a307f3d27ea427"
vpc_id             = "vpc-0046a802b5e298ba9"
subnet_id          = "subnet-0096a0bed0badcdde"
security_group_id  = "sg-03b12762a47d78143"
key_pair_name      = "kubernetes"
master_node_ip     = "172.31.38.211"
worker_count       = 2
instance_type      = "t2.medium"
pem_key_path       = "/home/ubuntu/kubernetes.pem"