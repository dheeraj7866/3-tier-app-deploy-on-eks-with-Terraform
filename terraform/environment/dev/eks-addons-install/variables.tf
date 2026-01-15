variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EKS networking"
  type        = string
}

variable "namespace" {
  default = "monitoring"
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "gmail_user" {
  type      = string
  sensitive = true
}

variable "gmail_app_password" {
  type      = string
  sensitive = true
}
