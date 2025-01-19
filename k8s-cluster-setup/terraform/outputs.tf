output "worker_ips" {
  description = "Public IPs of worker nodes"
  value       = aws_instance.worker.*.public_ip
}

output "inventory_file" {
  description = "Path to the Ansible inventory file"
  value       = local_file.inventory.filename
}
