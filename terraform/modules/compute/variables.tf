variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "asg_min_size" { type = number }
variable "asg_max_size" { type = number }
variable "asg_desired_capacity" { type = number }
variable "alb_security_group_id" { type = string }
variable "ec2_security_group_id" { type = string }
variable "logs_bucket_name" { type = string }
variable "certificate_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}