variable "name" {}
variable "vpc_cidr" {}

variable "subnet_cidrs" {
    type = "list"
}

variable "availability_zones" {
    type = "list"
}

variable "destination_cidr_block" {
    default = "0.0.0.0/0"
}