resource "aws_subnet" "subnets" {
  for_each = local.subnet_configs

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.is_public

  tags = merge({
    vpc_name                                                              = var.vpc_name
    "Name"                                                                = "${var.vpc_name}-${each.value.is_public ? "public" : "private"}-${each.value.availability_zone}-${var.environment}"
    "kubernetes.io/role/${each.value.is_public ? "elb" : "internal-elb"}" = "1"
    "kubernetes.io/cluster/${var.cluster_name_prefix}-${var.environment}" = "owned"
  }, var.tags)
}