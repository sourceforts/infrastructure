variable "cluster_name" {}
variable "iam_instance_profile_id" {}
variable "aws_ami" {}
variable "user_data" {}
variable "subnet_ids" {
    type = "list"
}
variable "security_groups" {
    type = "list"
}

variable "instance_type" {
    default = "t2.micro"
}

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

variable "ecs_config" {
    default = "echo '' > /etc/ecs/ecs.config"
}

variable "ecs_logging" {
    default = "[\"json-file\",\"awslogs\"]"
}

variable "cloudwatch_prefix" {
    default = ""
}

