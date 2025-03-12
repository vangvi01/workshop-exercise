locals {
  private_subnet_configs = {
    for i, az in var.availability_zones : "private_${az}" => {
      cidr_block        = var.subnet_cidrs.private[i]
      availability_zone = az
      is_public         = false
    }
  }

  public_subnet_configs = {
    for i, az in var.availability_zones : "public_${az}" => {
      cidr_block        = var.subnet_cidrs.public[i]
      availability_zone = az
      is_public         = true
    }
  }

  # Merge both configs
  subnet_configs = merge(local.private_subnet_configs, local.public_subnet_configs)
}