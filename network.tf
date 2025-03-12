module "network" {
  source = "./modules/network"

  vpc_name             = local.config.network.vpc_name
  cidr_block           = local.config.network.cidr_block
  enable_dns_support   = local.config.network.enable_dns_support
  cluster_name_prefix  = local.config.network.is_eks_vpc ? local.config.eks.cluster_name_prefix : null
  enable_dns_hostnames = local.config.network.enable_dns_hostnames
  environment          = local.config.global.environment
  availability_zones   = local.config.global.availability_zones
  subnet_cidrs         = local.config.network.subnet_cidrs
  tags                 = try(merge(local.config.network.resource_tags, local.config.global.tags), local.config.global.tags)
}