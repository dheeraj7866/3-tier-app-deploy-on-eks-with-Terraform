provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./../../../modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
  cluster_name         = module.eks.cluster_name 
}

module "eks" {
  source               = "./../../../modules/eks"
  cluster_name         = var.cluster_name
  cluster_version      = var.cluster_version
  region               = var.region
  private_subnet_ids   = module.vpc.private_subnet_ids
  node_group_config    = var.node_group_config
  vpc_id               = module.vpc.vpc_id
  # providers = {
  #   kubernetes = kubernetes
  #   helm       = helm
  # }
}

data "tls_certificate" "eks_oidc" {
  url = module.eks.cluster_oidc_issuer_url
}

# Create the IAM OIDC identity provider
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
  url             = module.eks.cluster_oidc_issuer_url

  depends_on = [module.eks]
}
