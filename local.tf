locals {
  common_name = "${var.project}-${var.environment}"
  vpc_tags = merge({Name = "${local.common_name}"}, "${var.common_tags}")
  igw_tags = merge({Name = "${local.common_name}-igw"}, "${var.common_tags}")
  public_route_table_name = "${local.common_name}-public-route"
}