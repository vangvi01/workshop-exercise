output "vpc_id" {
  value = aws_vpc.main.id
}


output "subnet_ids" {
  value = {
    for k, v in aws_subnet.subnets : k => v.id
  }
}

output "private_subnet_ids" {
  value = [
    for k, v in aws_subnet.subnets : v.id if !v.map_public_ip_on_launch
  ]
}

output "public_subnet_ids" {
  value = [
    for k, v in aws_subnet.subnets : v.id if v.map_public_ip_on_launch
  ]
}