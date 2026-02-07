variable "region" {
  type    = string
  default = "us-east-1"
}

variable "account_id" {
  type    = string
  default = "878174833450"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "cluster_name" {
  type    = string
  default = "eks-lab-smarzaro"
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}