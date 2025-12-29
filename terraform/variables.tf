variable "key_name" {
  description = "Existing key pair"
  type        = string
}

variable "vpc_id" {
  default = "vpc-0baf60545710b29d8"
}

variable "subnet_id" {
  default = "subnet-0f82927f687432f0f"
}

