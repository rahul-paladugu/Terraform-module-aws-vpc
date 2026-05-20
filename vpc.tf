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
  count = length(var.cidr_subnet_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_subnet_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge({ Name = var.public_subnents[count.index] }, var.common_tags)
}