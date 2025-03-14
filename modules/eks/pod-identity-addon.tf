resource "aws_eks_addon" "pod_identity" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.5-eksbuild.2"
}


# aws eks describe-addon-versions \
#     --kubernetes-version=1.32 \
#     --addon-name=eks-pod-identity-agent\
#     --query='addons[].addonVersions[].addonVersion'