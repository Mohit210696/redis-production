output "bastion_private_ip" {
  value = data.aws_instance.bastion.private_ip
}

output "redis_private_ips" {
  value = [
    data.aws_instance.redis_1.private_ip,
    data.aws_instance.redis_2.private_ip,
    data.aws_instance.redis_3.private_ip
  ]
}
output "environment" {
  value = terraform.workspace
}

