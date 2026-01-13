#################################
# Bastion EC2
#################################
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name        = "bastion"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
}

#################################
# Redis EC2 Nodes
#################################
resource "aws_instance" "redis" {
  count                  = var.redis_count
  ami                    = var.ami_id
  instance_type          = var.redis_instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.redis.id]

  tags = {
    Name        = "redis-${count.index + 1}"
    Environment = var.environment
    Role        = "redis"
  }
}

