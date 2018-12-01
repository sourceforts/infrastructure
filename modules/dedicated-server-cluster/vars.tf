variable "region" {
    description = "AWS region to deploy"
    default = "us-east-1"
}

variable "env" {
    default = "sourceforts"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
    type = "list"
    default = [
        "10.0.0.0/24",
    ]
}

variable "min_size" {
    default = 1
}

variable "max_size" {
    default = 1
}

variable "desired_capacity" {
    default = 1
}

variable "instance_group" {
    default = "default"
}

locals {
    instance_type = "t2.nano"
}
