data "aws_security_group" "bastion" {
  id = "sg-0e65f51e71e83ae2c"
}

data "aws_security_group" "redis" {
  id = "sg-0c3d8d484cd3b8a94"
}

data "aws_security_group" "monitoring" {
  id = "sg-0c2aa08cbe04e8ace"
}

