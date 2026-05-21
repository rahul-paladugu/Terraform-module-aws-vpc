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

variable "public_subnet_cidrs" {
  type = list
}

variable "private_subnet_cidrs" {
  type = list
}

variable "database_subnet_cidrs" {
  type = list
}

variable "az_names" {
  type = list
}

variable "internet_cidr" {
  type = string
}

