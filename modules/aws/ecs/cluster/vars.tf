variable "name" {}
variable "cluster_name" {}
variable "vpc_id" {}

variable "instance_type" {}
variable "ecs_aws_ami" {}

variable "instance_group" {
    default = "default"
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

variable "custom_user_data" {
    default = ""
}

variable "ecs_config" {
    default = "echo '' > /etc/ecs/ecs.config"
}

variable "ecs_logging" {
    default = "[\"json-file\",\"awslogs\"]"
}

variable "cloudwatch_prefix" {
    default = ""
}