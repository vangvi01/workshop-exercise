## Init providers for Terraform locally (for the workshop)
provider "aws" {
  region = local.config.global.region

}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

## We can also use the following configuration for EKS and OIDC authentication with Terraform Cloud or GitHub Actions.
# provider "aws" {
#   region = "local.config.global.region"  # Change to your preferred region

#   # OIDC authentication configuration
#   assume_role_with_web_identity {
#     role_arn                = "arn:aws:iam::123456789012:role/github-actions-role"
#     session_name            = "TerraformSession"
#     web_identity_token_file = "/path/to/token/file"
#   
#   }
# }
# provider "kubernetes" {
#   host                   = module.eks.eks.endpoint
#   cluster_ca_certificate = base64decode(module.eks.eks.certificate_authority[0].data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", module.eks.eks.name]
#     command     = "aws"
#   }
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.eks.endpoint
#     cluster_ca_certificate = base64decode(module.eks.eks.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.eks.token
#   }
# }


