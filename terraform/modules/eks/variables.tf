variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
variable "region" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "node_group_config" {
  type = object({
    desired_capacity = number
    min_capacity     = number
    max_capacity     = number
    instance_types   = list(string)
  })
}
