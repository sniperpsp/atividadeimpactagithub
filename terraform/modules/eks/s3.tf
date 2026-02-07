terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
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
