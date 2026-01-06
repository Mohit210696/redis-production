terraform {
  backend "s3" {
    bucket         = "redis-production-terraform-state-mohit"
    key            = "redis-production/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

