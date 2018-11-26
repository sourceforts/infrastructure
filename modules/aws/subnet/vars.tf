variable "provider" {
    default = "default"
}

variable "name" {}
variable "vpc_id" {}

variable "cidr_blocks" {
    type = "list"
}

variables "availability_zones" {
    type = "list"
}
