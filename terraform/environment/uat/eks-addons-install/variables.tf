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

# variable "node_group_name" {
#   description = "EKS Node group name"
#   type        = string
# }

# variable "addon" {
#   description = "Addon type (alb, ebs, autoscaler, metrics)"
#   type        = string
#   default     = ""
# }
