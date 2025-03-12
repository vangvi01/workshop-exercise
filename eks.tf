module "eks" {
  source = "./modules/eks"

  cluster_name_prefix = local.config.eks.cluster_name_prefix
  cluster_version     = local.config.eks.cluster_version
  environment         = local.config.global.environment
  region              = local.config.global.region
  subnet_ids          = module.network.private_subnet_ids
  vpc_id              = module.network.vpc_id
  node_group_name     = local.config.eks.node_group_name
  instance_types      = local.config.eks.instance_types
  scaling_config      = local.config.eks.scaling_config
  tags                = try(merge(local.config.eks.resource_tags, local.config.global.tags), local.config.global.tags)
}