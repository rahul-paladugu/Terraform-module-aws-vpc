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