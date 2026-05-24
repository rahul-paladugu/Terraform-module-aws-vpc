output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "database_subnets" {
  value = aws_subnet.database[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "database_route_table_id" {
  value = aws_route_table.database.id
}

output "eip_id" {
  value = aws_eip.nat.id
}

output "nat_gateway_id" {
  value = aws.aws_nat_gateway.main.id
}