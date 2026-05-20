resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  tags = local.vpc_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = local.igw_tags
}

resource "aws_subnet" "main" {
  count = length(var.subnet_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge({ Name = var.public_subnents[count.index] }, var.common_tags)
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_route_cidr_blocks
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge({Name = local.public_route_table_name}, var.common_tags)
}