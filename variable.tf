variable "cidr_block" {
  type = string
  description = "Please provide the VPC CIDR"
}

variable "project" {
  type = string
}

variable "environment" {
    type = string
}

variable "common_tags" {
    type = map
    default = {
        Terraform = "True"
    }
}

variable "cidr_subnet_blocks" {
  type = list
}

variable "availability_zones" {
  type = list
}

variable "public_subnents" {
  type = list
}