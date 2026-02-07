variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block para VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks para subnets públicas"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks para subnets privadas de aplicação"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks para subnets privadas de banco de dados"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Usar apenas 1 NAT Gateway (economia de custos)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
