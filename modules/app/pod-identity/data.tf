data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "web_server_eks" {
  name = var.cluster_name
}

data "tls_certificate" "cluster_certificate" {
  url = data.aws_eks_cluster.web_server_eks.identity.0.oidc.0.issuer
}

