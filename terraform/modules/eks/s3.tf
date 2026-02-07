terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    encrypt        = true
    bucket         = "quickorder-s3"
    key            = "cluster.tfstate"
    profile        = "default"
    region         = "us-east-2"
    #dynamodb_table = "dock-tf-locks"
  }
}
