resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  tags = local.vpc_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = local.igw_tags
}

resource "aws_subnet" "public" {
  count = length(var.public.subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.az_names[count.index]
  map_public_ip_on_launch = true
  tags = merge({ Name = "${local.common_name}-public-${var.az_names[count.index]}" }, var.common_tags)
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.az_names[count.index]
  tags = merge({ Name = "${local.common_name}-private-${var.az_names[count.index]}" }, var.common_tags)
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = var.az_names[count.index]
  tags = merge({ Name = "${local.common_name}-database-${var.az_names[count.index]}" }, var.common_tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge({Name = local.public_route_table_name}, var.common_tags)
}



resource "aws_route_table_association" "main" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}