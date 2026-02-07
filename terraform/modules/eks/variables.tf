# ==============================================================================
# EKS Module Variables
# ==============================================================================

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets privadas para os nodes"
  type        = list(string)
}

variable "cluster_version" {
  description = "Versão do Kubernetes"
  type        = string
}

variable "node_instance_type" {
  description = "Tipo de instância dos nodes"
  type        = string
}

variable "node_min_size" {
  description = "Número mínimo de nodes"
  type        = number
}

variable "node_max_size" {
  description = "Número máximo de nodes"
  type        = number
}

variable "node_desired_size" {
  description = "Número desejado de nodes"
  type        = number
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default     = {}
}