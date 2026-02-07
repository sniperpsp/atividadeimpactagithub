variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "engine_version" { type = string }
variable "database_name" { type = string }
variable "backup_retention_period" { type = number }
variable "multi_az" { type = bool }
variable "allowed_security_group_ids" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}
