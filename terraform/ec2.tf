data "aws_instance" "bastion" {
  instance_id = "i-09ca867a29d863695"
}

data "aws_instance" "redis_1" {
  instance_id = "i-0c2b4e4c28e53c821"
}

data "aws_instance" "redis_2" {
  instance_id = "i-0a2d20bfec205acd0"
}

data "aws_instance" "redis_3" {
  instance_id = "i-00b9ae5b445243cf4"
}

