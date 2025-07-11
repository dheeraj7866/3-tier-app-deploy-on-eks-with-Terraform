region             = "us-west-1"
cluster_name       = "equity-uat-cluster"
cluster_version    = "1.32"
vpc_cidr           = "10.10.0.0/16"
public_subnet_cidrs = ["10.10.3.0/24", "10.10.4.0/24"]
private_subnet_cidrs = ["10.10.103.0/24", "10.10.104.0/24"]
availability_zones = ["us-west-1b", "us-west-1c"]
environment        = "uat"
node_group_config = {
  desired_capacity = 2
  min_capacity     = 2
  max_capacity     = 5
  instance_types   = ["t3.medium"]
}
