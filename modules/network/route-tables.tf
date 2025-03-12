resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.vpc_name}-private-${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public"
  }
}


resource "aws_route_table_association" "private" {
  for_each = {
    for k, v in aws_subnet.subnets : k => v if !v.map_public_ip_on_launch
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  for_each = {
    for k, v in aws_subnet.subnets : k => v if v.map_public_ip_on_launch
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}