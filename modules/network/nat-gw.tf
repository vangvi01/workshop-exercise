resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.vpc_name}-igw"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = [for k, v in aws_subnet.subnets : v.id if v.map_public_ip_on_launch][0] # creating only one nat gateway for now in one public subnet

  tags = merge(
    { Name = "${var.vpc_name}-igw" },
    var.tags
  )


  depends_on = [aws_internet_gateway.igw]
}
