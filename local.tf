locals {
  common_name = "${var.project}-${var.environment}"
  vpc_tags = merge({Name = "${local.common_name}"}, "${var.common_tags}")
}