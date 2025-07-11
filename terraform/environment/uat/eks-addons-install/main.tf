

data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "cluster_autoscaler" {
  source       = "../../../modules/eks-addons/cluster-autoscaler"
  region       = var.region
  cluster_name = var.cluster_name
}

module "alb-controller" {
  source       = "../../../modules/eks-addons/alb-controller"
  region       = var.region
  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
}

module "ebs-csi-driver" {
  source       = "../../../modules/eks-addons/ebs-csi-driver"
  region       = var.region
  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
}
