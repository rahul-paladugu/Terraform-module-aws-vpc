# VPC

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "The ARN of the VPC."
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "The primary IPv4 CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

# ─────────────────────────────────────────────────────────────────────────────
# INTERNET GATEWAY
# ─────────────────────────────────────────────────────────────────────────────

output "igw_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.main.id
}

output "igw_arn" {
  description = "ARN of the Internet Gateway."
  value       = aws_internet_gateway.main.arn
}

# ─────────────────────────────────────────────────────────────────────────────
# SUBNETS — IDs
# ─────────────────────────────────────────────────────────────────────────────

output "public_subnet_ids" {
  description = "List of IDs of the public subnets, in AZ order."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of the private (application) subnets, in AZ order."
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "List of IDs of the isolated database subnets, in AZ order."
  value       = aws_subnet.database[*].id
}

# ─────────────────────────────────────────────────────────────────────────────
# SUBNETS — CIDR blocks (useful for SG rules referencing subnet ranges)
# ─────────────────────────────────────────────────────────────────────────────

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of the public subnets."
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "List of CIDR blocks of the private subnets."
  value       = aws_subnet.private[*].cidr_block
}

output "database_subnet_cidrs" {
  description = "List of CIDR blocks of the database subnets."
  value       = aws_subnet.database[*].cidr_block
}

# ─────────────────────────────────────────────────────────────────────────────
# SUBNETS — AZ mapping (convenient for targeting a specific AZ)
# ─────────────────────────────────────────────────────────────────────────────

output "public_subnets_by_az" {
  description = "Map of AZ name → public subnet ID."
  value       = zipmap(var.az_names, aws_subnet.public[*].id)
}

output "private_subnets_by_az" {
  description = "Map of AZ name → private subnet ID."
  value       = zipmap(var.az_names, aws_subnet.private[*].id)
}

output "database_subnets_by_az" {
  description = "Map of AZ name → database subnet ID."
  value       = zipmap(var.az_names, aws_subnet.database[*].id)
}

# ─────────────────────────────────────────────────────────────────────────────
# NAT GATEWAY / EIP
# ─────────────────────────────────────────────────────────────────────────────

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs. Empty if enable_nat_gateway = false."
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "List of public Elastic IPs assigned to the NAT Gateways."
  value       = aws_eip.nat_eip.public_ip
}


# ─────────────────────────────────────────────────────────────────────────────
# ROUTE TABLES
# ─────────────────────────────────────────────────────────────────────────────

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "List of private route table IDs (one per NAT GW, or one if single_nat_gateway = true)."
  value       = aws_route_table.private[*].id
}

output "database_route_table_ids" {
  description = "List of database route table IDs."
  value       = aws_route_table.database[*].id
}



# ─────────────────────────────────────────────────────────────────────────────
# LEGACY ALIASES — kept for backwards compatibility with existing callers
# that reference the old output names. Will be removed in v2.0.
# ─────────────────────────────────────────────────────────────────────────────

output "public_subnets" {
  description = "DEPRECATED: use public_subnet_ids. Kept for backwards compatibility."
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "DEPRECATED: use private_subnet_ids. Kept for backwards compatibility."
  value       = aws_subnet.private[*].id
}

output "database_subnets" {
  description = "DEPRECATED: use database_subnet_ids. Kept for backwards compatibility."
  value       = aws_subnet.database[*].id
}

output "nat_gateway_id" {
  description = "DEPRECATED: use nat_gateway_id. Kept for backwards compatibility."
  value       = aws_nat_gateway.main
}

output "eip_id" {
  description = "DEPRECATED: use eip_id. Kept for backwards compatibility."
  value       = aws_eip.nat_eip.public_ip
}
