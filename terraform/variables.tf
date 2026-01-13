variable "ami_id" {}
variable "subnet_id" {}
variable "key_name" {}
variable "environment" {}

variable "redis_count" {
  default = 3
}

variable "redis_instance_type" {
  default = "t3.small"
}

variable "bastion_instance_type" {
  default = "t3.micro"
}

