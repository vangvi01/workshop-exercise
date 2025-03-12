# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.eks.name

#   depends_on = [
#     module.eks
#   ]
# }