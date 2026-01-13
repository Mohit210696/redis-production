output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "redis_private_ips" {
  value = aws_instance.redis[*].private_ip
}

output "environment" {
  value = var.environment
}

